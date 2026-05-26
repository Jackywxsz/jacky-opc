#!/usr/bin/env python3
"""
Article Illustration Generator

This script is mainly used to generate illustrations for articles and convert
them into beautifully designed HTML pages using the Gemini Image API.

Usage:
    GOOGLE_API_KEY="your-key" python article_to_html.py <article_file> [--images N] [--model MODEL]

Arguments:
    article_file    Path to the text article file
    --images N      Number of images to generate (default: 5)
    --model MODEL   Gemini model to use (default: gemini-2.5-flash-image)
    --ratio RATIO   Image aspect ratio (default: 16:9)
    --size SIZE     Image resolution: small, medium, large (default: small for 1K)
"""

import os
import sys
import time
import io
import argparse
from google import genai
from google.genai import types
from PIL import Image

# Fix Windows console encoding
if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

# --- Configuration ---
DEFAULT_MODEL = "gemini-2.5-flash-image"
DEFAULT_IMAGE_COUNT = 5
DEFAULT_ASPECT_RATIO = "16:9"
DEFAULT_IMAGE_SIZE = "small"  # small=1K, medium=2K, large=4K

# Get script directory for template file (in skill folder)
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
SKILL_DIR = os.path.dirname(SCRIPT_DIR)
TEMPLATE_FILE = os.path.join(SKILL_DIR, "assets", "template.html")

# Output directory in current working directory (project folder)
OUTPUT_DIR = os.path.join(os.getcwd(), "output")

# Image size mapping (approximate resolutions)
IMAGE_SIZE_MAP = {
    "small": "1K",   # ~1024px
    "medium": "2K",  # ~2048px
    "large": "4K"    # ~4096px
}


def generate_scene_prompts(paragraphs, title, author, num_images):
    """
    Generate image prompts based on article paragraphs.
    Creates prompts by extracting key visual elements from the text.
    """
    print(f"\n正在生成 {num_images} 个场景描述...")

    scenes = []

    # First image: overall atmosphere (header)
    scenes.append({
        "prompt": f"A serene and poetic scene inspired by '{title}' by {author}, traditional Chinese painting style, soft moonlight, lotus pond, peaceful atmosphere, artistic and elegant",
        "caption": f"《{title}》"
    })

    # Distribute remaining images across paragraphs
    if num_images > 1 and len(paragraphs) > 0:
        # Select paragraphs evenly distributed throughout the article
        step = max(1, len(paragraphs) // (num_images - 1))
        selected_indices = [i * step for i in range(num_images - 1)]

        for idx, para_idx in enumerate(selected_indices, 1):
            if para_idx < len(paragraphs):
                paragraph = paragraphs[para_idx]

                # Extract key visual elements from paragraph (first 100 chars)
                excerpt = paragraph[:100] if len(paragraph) > 100 else paragraph

                # Create a generic but contextual prompt
                scenes.append({
                    "prompt": f"A scene from '{title}': {excerpt}... Traditional Chinese painting style, poetic atmosphere, soft lighting, elegant composition",
                    "caption": f"《{title}》插图 {idx}"
                })

    print(f"✓ 已生成 {len(scenes)} 个场景描述")
    return scenes


def generate_image(client, prompt, filename, aspect_ratio, image_size, model):
    """
    Generates an image using Gemini API and saves it to filename.
    Note: image_size parameter may not be supported by all API versions.
    """
    print(f"正在生成图片: {filename}...")
    try:
        # Try with image_size parameter first
        try:
            response = client.models.generate_content(
                model=model,
                contents=[prompt],
                config=types.GenerateContentConfig(
                    response_modalities=['TEXT', 'IMAGE'],
                    image_config=types.ImageConfig(
                        aspect_ratio=aspect_ratio,
                        image_size=IMAGE_SIZE_MAP.get(image_size, "1K")
                    )
                )
            )
        except Exception as size_error:
            # If image_size is not supported, try without it
            if "image_size" in str(size_error).lower() or "extra" in str(size_error).lower() or "invalid_argument" in str(size_error).lower() or "invalid argument" in str(size_error).lower():
                print(f"   ⚠ 注意: API不支持image_size参数，使用默认分辨率")
                response = client.models.generate_content(
                    model=model,
                    contents=[prompt],
                    config=types.GenerateContentConfig(
                        response_modalities=['TEXT', 'IMAGE'],
                        image_config=types.ImageConfig(
                            aspect_ratio=aspect_ratio
                        )
                    )
                )
            else:
                raise size_error

        for part in response.candidates[0].content.parts:
            if part.inline_data:
                img = Image.open(io.BytesIO(part.inline_data.data))
                output_path = os.path.join(OUTPUT_DIR, filename)
                img.save(output_path)
                print(f"✓ 已保存到 {output_path}")
                return True
        return False
    except Exception as e:
        print(f"✗ 生成 {filename} 时出错: {e}")
        return False


def read_article(article_file):
    """Read and parse the article text from file."""
    with open(article_file, 'r', encoding='utf-8') as f:
        content = f.read()

    lines = [line.strip() for line in content.split('\n') if line.strip()]

    if len(lines) < 2:
        raise ValueError("文章格式错误：至少需要标题和作者信息")

    # First line is title
    title = lines[0]

    # Second line might be author (check for "作者:" prefix)
    author = ""
    content_start = 1

    if len(lines) > 1:
        if "作者" in lines[1] or "Author" in lines[1]:
            author = lines[1].replace("作者:", "").replace("Author:", "").strip()
            content_start = 2
        else:
            # If no author line, use second line as first paragraph
            author = "佚名"
            content_start = 1

    # Rest are paragraphs
    paragraphs = lines[content_start:]

    return title, author, paragraphs, content


def create_html(title, author, paragraphs, image_files):
    """Create HTML file with article content and images."""

    # Read template
    with open(TEMPLATE_FILE, 'r', encoding='utf-8') as f:
        template = f.read()

    # Update header background image FIRST (before replacing title)
    # The template has: url('故都的秋4.png')
    header_image = image_files[0]["filename"]
    html = template.replace("url('故都的秋4.png')", f"url('{header_image}')")

    # Then replace title and author
    html = html.replace("故都的秋", title)
    html = html.replace("郁达夫", author)

    # Build article content with images
    article_content = ""

    # Calculate how to distribute images throughout the article
    num_paragraphs = len(paragraphs)
    num_images = len(image_files) - 1  # Exclude header image

    if num_images > 0:
        # Distribute images evenly throughout the article
        paragraphs_per_image = max(1, num_paragraphs // (num_images + 1))
    else:
        paragraphs_per_image = num_paragraphs

    image_index = 1  # Start from 1 (0 is header)

    for i, paragraph in enumerate(paragraphs):
        # Add paragraph
        article_content += f'            <p>{paragraph}</p>\n'

        # Add image after certain number of paragraphs
        if image_index < len(image_files) and (i + 1) % paragraphs_per_image == 0 and i < num_paragraphs - 1:
            article_content += f'''            <div class="article-image">
                <img src="{image_files[image_index]["filename"]}" alt="{image_files[image_index]["caption"]}">
                <span class="image-caption">{image_files[image_index]["caption"]}</span>
            </div>

'''
            image_index += 1

    # Replace the article section in template
    start_marker = '<article>'
    end_marker = '</article>'
    start_idx = html.find(start_marker)
    end_idx = html.find(end_marker)

    if start_idx != -1 and end_idx != -1:
        html = html[:start_idx + len(start_marker)] + '\n' + article_content + '        ' + html[end_idx:]

    # Update footer
    html = html.replace("故都的秋 - 图文排版", f"{title} - 图文排版")

    # Write output HTML
    # Sanitize filename
    safe_title = "".join(c for c in title if c.isalnum() or c in (' ', '-', '_')).strip()
    output_html = os.path.join(OUTPUT_DIR, f"{safe_title}.html")

    with open(output_html, 'w', encoding='utf-8') as f:
        f.write(html)

    print(f"\n✓ HTML文件已生成: {output_html}")
    return output_html


def main():
    """Main processing function."""

    # Parse command line arguments
    parser = argparse.ArgumentParser(
        description='Convert text articles to HTML with AI-generated illustrations',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__
    )
    parser.add_argument('article_file', help='Path to the text article file')
    parser.add_argument('--images', type=int, default=DEFAULT_IMAGE_COUNT,
                        help=f'Number of images to generate (default: {DEFAULT_IMAGE_COUNT})')
    parser.add_argument('--model', default=DEFAULT_MODEL,
                        help=f'Gemini model to use (default: {DEFAULT_MODEL})')
    parser.add_argument('--ratio', default=DEFAULT_ASPECT_RATIO,
                        help=f'Image aspect ratio (default: {DEFAULT_ASPECT_RATIO})')
    parser.add_argument('--size', default=DEFAULT_IMAGE_SIZE,
                        choices=['small', 'medium', 'large'],
                        help=f'Image resolution: small (1K), medium (2K), large (4K) - default: {DEFAULT_IMAGE_SIZE}')

    args = parser.parse_args()

    # Get API key
    api_key = os.environ.get("GOOGLE_API_KEY")
    if not api_key:
        print("错误: 请提供 Google API key")
        print("方法: 设置环境变量 GOOGLE_API_KEY")
        return 1

    # Check if article file exists
    if not os.path.exists(args.article_file):
        print(f"错误: 文章文件不存在: {args.article_file}")
        return 1

    # Check if template exists
    if not os.path.exists(TEMPLATE_FILE):
        print(f"错误: 模板文件不存在: {TEMPLATE_FILE}")
        print("请确保 references/template.html 文件存在")
        return 1

    # Create output directory
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    print("=" * 60)
    print("文章转HTML生成器 (Article to HTML Converter)")
    print("=" * 60)

    # Read article
    print(f"\n1. 读取文章: {args.article_file}")
    try:
        title, author, paragraphs, full_text = read_article(args.article_file)
        print(f"   标题: {title}")
        print(f"   作者: {author}")
        print(f"   段落数: {len(paragraphs)}")
    except Exception as e:
        print(f"错误: 读取文章失败: {e}")
        return 1

    # Initialize Gemini client
    print("\n2. 初始化 Gemini API 客户端...")
    try:
        client = genai.Client(api_key=api_key)
        print("   ✓ 客户端初始化成功")
    except Exception as e:
        print(f"错误: 初始化客户端失败: {e}")
        return 1

    # Generate scene prompts based on paragraphs
    scenes = generate_scene_prompts(paragraphs, title, author, args.images)

    # Prepare image filenames
    base_name = "".join(c for c in title if c.isalnum() or c in (' ', '-', '_')).strip()
    for i, scene in enumerate(scenes):
        if i == 0:
            scene['filename'] = f"{base_name}_header.png"
        else:
            scene['filename'] = f"{base_name}_{i}.png"

    # Generate images
    print(f"\n3. 生成 {len(scenes)} 张插图...")
    print(f"   模型: {args.model}")
    print(f"   比例: {args.ratio}")
    print(f"   分辨率: {args.size} ({IMAGE_SIZE_MAP.get(args.size, '1K')})")

    generated_images = []
    for i, scene in enumerate(scenes, 1):
        print(f"\n   [{i}/{len(scenes)}] {scene['caption']}")
        success = generate_image(
            client,
            scene["prompt"],
            scene["filename"],
            args.ratio,
            args.size,
            args.model
        )
        if success:
            generated_images.append(scene)
        time.sleep(2)  # Rate limiting

    if not generated_images:
        print("\n错误: 没有成功生成任何图片")
        return 1

    print(f"\n   ✓ 成功生成 {len(generated_images)}/{len(scenes)} 张图片")

    # Create HTML
    print("\n4. 生成 HTML 文件...")
    try:
        output_file = create_html(title, author, paragraphs, generated_images)
    except Exception as e:
        print(f"错误: 生成HTML失败: {e}")
        return 1

    print("\n" + "=" * 60)
    print("✓ 处理完成!")
    print(f"输出目录: {OUTPUT_DIR}/")
    print(f"HTML文件: {output_file}")
    print(f"图片文件: {len(generated_images)} 张")
    print("=" * 60)

    return 0


if __name__ == "__main__":
    sys.exit(main())
