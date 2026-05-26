# Nano Banana Pro (Gemini 3 Pro Image) API Calling Guide

Nano Banana Pro (`gemini-3-pro-image-preview`) is a state-of-the-art image generation and editing model optimized for professional asset production and complex creative workflows.

## 1. Model Profile
- **Model ID**: `gemini-3-pro-image-preview`
- **Focus**: Professional asset production, high-fidelity text rendering, complex instruction following.
- **Watermarking**: All generated images include a SynthID watermark.

## 2. Key Capabilities
- **High-Resolution**: Native support for 1K, 2K, and 4K visuals.
- **Advanced Text Rendering**: Precise rendering of stylized text (menus, infographics, diagrams).
- **Grounding with Search**: Optional tool to verify facts or use real-time data.
- **Thinking Mode**: Internal reasoning process to refine composition (higher quality, no extra charge for "thoughts").
- **Reference Images**: Supports up to 14 reference images (6 objects, 5 characters).

## 3. Configuration Parameters
### ImageConfig
Used within `GenerateContentConfig` to control output properties.
- **aspect_ratio**: `"1:1"`, `"2:3"`, `"3:2"`, `"3:4"`, `"4:3"`, `"4:5"`, `"5:4"`, `"9:16"`, `"16:9"`, `"21:9"`
- **image_size**: `"1K"`, `"2K"`, `"4K"`

### GenerateContentConfig
- **response_modalities**: Must include `['TEXT', 'IMAGE']` or `["TEXT", "IMAGE"]`.
- **tools**: Optional, e.g., `[{"google_search": {}}]`.

## 4. Usage Patterns (Python Example)

### A. Single-Turn Text-to-Image
```python
from google import genai
from google.genai import types
from PIL import Image

client = genai.Client()
response = client.models.generate_content(
    model="gemini-3-pro-image-preview",
    contents=["Create a high-fidelity 4K infographic of solar system with labels"],
    config=types.GenerateContentConfig(
        response_modalities=['TEXT', 'IMAGE'],
        image_config=types.ImageConfig(
            aspect_ratio="16:9",
            image_size="4K"
        )
    )
)
# Save resulting part.as_image()
```

### B. Multi-Turn Conversational Editing (Recommended)
Recommended for iterative refinement.
> [!IMPORTANT]
> **Thought Signatures**: In multi-turn conversations, the model returns a `thought_signature`. If you are using the official SDK's `chat` feature, this is handled automatically. If building a custom implementation, you **must** pass this signature back in subsequent turns to maintain the thinking context.

```python
chat = client.chats.create(
    model="gemini-3-pro-image-preview",
    config=types.GenerateContentConfig(response_modalities=['TEXT', 'IMAGE'])
)
# Turn 1: Initial generation
response1 = chat.send_message("Generate a professional logo for a space tech startup.")
# Turn 2: Modification (Thought signatures handled by SDK)
response2 = chat.send_message("Make the background darker and add the text 'ASTRO' in a sleek font.")
```

### C. Reference Image Mixing (Up to 14)
```python
response = client.models.generate_content(
    model="gemini-3-pro-image-preview",
    contents=[
        "An office group photo of these people making funny faces.",
        Image.open('person1.png'), # Character reference
        Image.open('person2.png'),
        # ... up to 14 images total
    ],
    config=types.GenerateContentConfig(
        response_modalities=['TEXT', 'IMAGE'],
        image_config=types.ImageConfig(aspect_ratio="5:4", image_size="2K")
    )
)
```

## 5. Safety & Responsible AI
- **SynthID**: All images contain a digital watermark.
- **Safety Filters**: Standard Gemini safety filters apply to both input prompts and generated output.
- **Prohibited Content**: Avoid generating content that infringes on rights, harms, or deceives.

## 6. Summary Table
| Feature | Supported / Value |
| :--- | :--- |
| **Model Name** | `gemini-3-pro-image-preview` |
| **Max Ref Images** | 14 (Mixed: 6 Objects / 5 Humans) |
| **Resolution** | 1K, 2K, 4K (Must be uppercase) |
| **Aspect Ratios** | 10 types (from 1:1 to 21:9) |
| **Search Integration** | Supported via Google Search tool |
| **Thinking Mode** | Always enabled for this model |
| **Thought Signatures** | Required for custom multi-turn |
