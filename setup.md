# Antigravity 2.0 Voxel & Godot Environment — Setup & Migration Guide

> **Repository**: [https://github.com/JeffNa1/antigravity-voxel-godot-setup](https://github.com/JeffNa1/antigravity-voxel-godot-setup)  
> **Author**: JeffNa1  
> **Purpose**: One-click portable environment bootstrap for Antigravity 2.0 sessions across any machine.

---

## 🚀 1. Quick Start (Cài Đặt Nhanh 1 Lệnh)

Khi bắt đầu một session mới hoặc chuyển sang máy tính khác, chỉ cần mở **PowerShell** và chạy lệnh sau để tự động cài đặt toàn bộ Skills, MCP servers, và Configurations:

```powershell
irm https://raw.githubusercontent.com/JeffNa1/antigravity-voxel-godot-setup/main/bootstrap.ps1 | iex
```

Hoặc clone thủ công và chạy installer:

```powershell
git clone https://github.com/JeffNa1/antigravity-voxel-godot-setup.git
cd antigravity-voxel-godot-setup
.\install.ps1
```

Sau khi chạy xong, hãy xác nhận hệ thống bằng script kiểm tra:

```powershell
.\verify.ps1
```

### 🤖 Tự Động Kích Hoạt & Thực Thi Bắt Buộc Qua AI Agent (Zero-Click Enforcement)
Nếu bạn mở một session Antigravity mới và ném repo hoặc gửi đường link GitHub này cho AI:
> Nhờ chỉ thị bắt buộc được đặt ở đầu `GEMINI.md` / `AGENTS.md` (`⚡ 0. AUTOMATIC BOOTSTRAP & ENFORCEMENT DIRECTIVE`), **MỖI KHI BƯỚC VÀO SESSION MỚI, AI AGENT BẮT BUỘC PHẢI TỰ ĐỘNG KIỂM TRA VÀ CÀI ĐẶT ĐỦ 34 SKILLS VÀ 7 MCP SERVERS**:
> 1. Tự động kiểm tra số lượng skills và MCP servers hiện tại.
> 2. Nếu thiếu, tự động chạy `install.ps1` (hoặc `bootstrap.ps1` trên môi trường mới).
> 3. Tự động chạy `verify.ps1` và xác nhận toàn bộ 34 skills và 7 MCP servers đã sẵn sàng trước khi thực hiện bất kỳ yêu cầu nào khác.

---

## 📦 2. Thành Phần Môi Trường (Environment Architecture)

Kho lưu trữ này bao gồm toàn bộ thiết lập đồng bộ cho 3 mảng trọng tâm:
1. **3D Voxel Creation**: MagicaVoxel `.vox`, Blockbench modeling, palette extraction, procedural voxel generation, Three.js live viewer.
2. **Godot Engine 4.x**: Skeletal inverse kinematics, realtime procedural rigs, live scene tree bridge, and movie recording.
3. **Remotion Studio**: Full HD / 4K programmatic video animation, retro voxel game HUD overlays, and automated media encoding.

```
~/.gemini/
├── antigravity/
│   ├── mcp_config.json            # MCP server registry (7 servers)
│   ├── mcp/                       # Lazy-loaded tool schemas (JSON) & instructions.md
│   │   ├── blender/
│   │   ├── blockbench/
│   │   ├── blockworld/
│   │   ├── godot-bridge/
│   │   ├── remotion/
│   │   └── voxel/
│   ├── mcp_servers/               # Compiled MCP runners
│   │   ├── voxel-mcp/             # TypeScript procedural voxel engine
│   │   ├── blockbench-mcp/        # Blockbench automation bridge
│   │   └── blockworld/            # Node.js generative voxel world with Three.js live viewer
│   └── skills/                    # Global Antigravity skills (34 skills)
└── config/
    ├── config.json                # Global user preferences & turbo policies
    ├── mcp_config.json            # Duplicate mirror for IDE resilience
    └── skills/                    # Active skills directory (34 skills)
```

---

## 🛠️ 3. Chi Tiết 7 MCP Servers

| Server Name | Runner Command | Chức Năng Chính | Các Tool Nổi Bật |
| :--- | :--- | :--- | :--- |
| **`godot`** | `node .../godot-mcp/build/index.js` | Điều khiển Godot 4 headless, chạy test scene, compile shader | Command execution, export, headless testing |
| **`godot-bridge`** | `node .../godot-mcp-bridge/dist/index.js` | Kết nối runtime với Godot Editor / Scene Tree qua TCP | `scene_tree_dump`, `add_node`, `connect_signal`, `take_screenshot`, `batch_scene_edit` |
| **`voxel`** | `node .../voxel-mcp/dist/index.js` | Engine xử lý 3D voxel, xuất file `.vox`, `.obj`, palette | `create_model`, `fill_box`, `flood_fill`, `export_gltf`, `save_vox`, `generate_character` (80+ tools) |
| **`blockbench`** | `node .../blockbench-mcp/dist/index.js` | Tự động hóa Blockbench: tạo cube, UV mapping, xương, keyframe | `add_cube`, `add_group`, `create_rig`, `create_animation`, `export_model` (40+ tools) |
| **`blender`** | `uvx blender-mcp` | Điều khiển Blender 4 bằng Python, tải model Sketchfab / Polyhaven | `execute_blender_code`, `search_polyhaven_assets`, `import_generated_asset` |
| **`remotion`** | `node .../@remotion/mcp/dist/index.js` | Tra cứu tài liệu và build Remotion video studio | `remotion-documentation` |
| **`blockworld`** | `node .../blockworld/server.js` | Dựng voxel theo khối lớn và Three.js live viewer trực tiếp | `world_info`, `place_box`, `place_cylinder`, `place_cone`, `place_sphere`, `place_tube`, `mirror`, `clear` |

---

## 🧠 4. Danh Sách 34 Antigravity Skills

### Voxel & Game Modeling (17 Skills)
- **`voxel-modeling`**: Quy trình tạo hình khối voxel 3D, tối ưu hóa mesh, quản lý palette màu chuẩn MagicaVoxel.
- **`voxel-art`**: Kỹ thuật MagicaVoxel chuyên sâu, phong cách Teardown, greedy meshing, AO baking và tối ưu đa giác.
- **`voxel-icon`**: Thiết kế icon vật phẩm khối isometric 3D, animation loop 4 khung hình cho HUD.
- **`voxel-rigging`**: Kỹ thuật phân cấp xương, trọng số 100% per-limb rigid weight painting, socket pivot points.
- **`voxel-animating`**: Nguyên tắc hoạt họa voxel, chu kỳ bước đi (walk cycle), idle thở, jump, blend state machine.
- **`voxel-godot-pipeline`**: Tích hợp Godot 4: cấu hình texture pixel-crisp, CharacterBody3D, AnimationTree, GridMap.
- **`blockbench-pipeline`**: Quy trình tạo model low-poly, UV atlas unwrap, khung xương và export glTF sang Godot.
- **`blockbench-modeling`**: Kỹ thuật box modeling nâng cao, quản lý cube budget, pivot alignments.
- **`blockbench-animation`**: Hoạt họa voxel theo phong cách stepped hoặc linear, arc tấn công và squash & stretch.
- **`blockbench-texturing`**: Trải UV layout, đồng nhất texel density, vẽ pixel art và highlight cạnh.
- **`blockbench-pbr-materials`**: Thiết lập Normal maps, roughness, metalness, emission masks cho Blockbench.
- **`blockbench-hytale`**: Tỷ lệ nhân vật và quy chuẩn thẩm mỹ voxel fantasy theo phong cách Hytale.
- **`blockworld`**: Quy chuẩn tỷ lệ thế giới khối, bảng màu 100 vật liệu và kỹ thuật tạo khối hình học lớn.
- **`dragon`**: Kỹ thuật tạo hình sinh vật rồng/quái thú voxel: sống lưng chữ S, cánh màng, móng vuốt, sừng.
- **`castle`**: Kiến trúc lâu đài cổ tích voxel: tháp nhọn witch-hat vươn cao, pháo đài, ban công gothic.
- **`weapon-design`**: Thiết kế vũ khí (dao găm ngọc, kiếm ma thuật, trượng phép) tỉ lệ chuẩn tay cầm.
- **`vehicle-design`**: Thiết kế phương tiện cơ giới dạng khối voxel/low-poly: xe cộ, robot mech, phi thuyền.

### Remotion Video Automation (12 Skills)
- **`remotion-best-practices`**: Router và cẩm nang kiến trúc code Remotion.
- **`remotion-create`**: Khởi tạo project Remotion mới với Tailwind / TypeScript.
- **`remotion-render`**: Render video CLI bằng ffmpeg, tùy chỉnh FPS, bit-rate, CRF, codec.
- **`remotion-studio`**: Preview video thời gian thực trong trình duyệt.
- **`remotion-markup`**: Xây dựng UI, hoạt ảnh easing, lò xo (spring), interpolation.
- **`remotion-interactivity`**: Tương tác trong video Remotion.
- **`remotion-captions`**: Phụ đề tự động và hiệu ứng chữ động.
- **`remotion-multimedia`**: Xử lý âm thanh, video lồng ghép với Mediabunny.
- **`remotion-maps`**: Bản đồ hoạt họa trong Remotion.
- **`remotion-saas`**: Xây dựng ứng dụng web render video tự động.
- **`remotion-docs`**: Tra cứu API Remotion mới nhất.
- **`remotion-upgrade`**: Nâng cấp các gói Remotion an toàn.

### Antigravity Core & Guides (5 Skills)
- **`agy-customizations`**: Hướng dẫn xây dựng và tùy biến Skill, Rule, Plugin, Hook, MCP server.
- **`antigravity_guide`**: Cẩm nang tra cứu toàn diện về Antigravity CLI, IDE, Slash commands, Keybindings.
- **`generative_ui`**: Tạo giao diện HTML/JS widget tương tác inline trong chat hoặc artifact.
- **`migrate-workflows`**: Chuyển đổi workflow cũ sang skills chuẩn.
- **`permissioned-github`**: Hướng dẫn quản lý quyền và token an toàn cho GitHub CLI.

---

## 📜 5. Hướng Dẫn & Quy Tắc Agent (Instructions & Workspace Rules)

Kho lưu trữ bao gồm bộ hướng dẫn chi tiết dành riêng cho AI Agent (Antigravity 2.0) để đảm bảo Agent khi được gọi trong bất kỳ session hay thư mục nào đều lập tức nắm rõ vai trò, tiêu chuẩn mỹ thuật và quy trình kỹ thuật:

### A. Hệ thống Agent Instructions Toàn cục (`GEMINI.md` / `AGENTS.md` / `INSTRUCTIONS.md`)
- **Vai trò chuyên biệt**: Lead 3D Voxel Artist, Godot 4 Gameplay Engineer, Remotion Motion Graphics Producer.
- **Tiêu chuẩn Voxel**: Tọa độ chuẩn Y-up, kích thước bounds chuẩn (32x32x32 hoặc 64x64x64), palette màu 256 giới hạn theo faction/material, greedy meshing tối ưu hóa số lượng đa giác.
- **Tiêu chuẩn Godot 4**: Quy định bắt buộc dùng texture filter `Nearest` (`texture_filter = 0`), tắt mipmaps để giữ độ sắc nét pixel-crisp, cấu trúc CharacterBody3D, AnimationTree state blending.
- **Tiêu chuẩn Hoạt ảnh Blockbench**: Phân cấp xương chuẩn (`root` -> `hips` -> `spine` -> `chest` -> `head`, các chi), **100% rigid weight-painting** (không biến dạng mềm giữa các khớp khối), đặt pivot point chính xác tại tâm ổ khớp.
- **Tiêu chuẩn Remotion Video**: Video không dùng filter blur làm mờ chi tiết pixel, font chữ pixel retro (`Press Start 2P`, `VT323`), chuyển cảnh `spring()` và camera `interpolate()`, khớp nhạc BGM theo nhịp tự nhiên kèm fade-in 0.2s và fade-out 1.5s.

### B. Hướng dẫn từng MCP Server (`mcp/<server>/instructions.md`)
Mỗi MCP server đều đi kèm tài liệu hướng dẫn chuẩn cách gọi tool và xử lý lỗi:
- `mcp/godot-bridge/instructions.md`: Kiểm tra port TCP, dump scene tree, chỉnh sửa node an toàn, chụp screenshot kiểm chứng.
- `mcp/voxel/instructions.md`: Khởi tạo model, các hàm procedural generator, biến đổi khối, xuất `.vox`/`.gltf`.
- `mcp/blockbench/instructions.md`: Tạo cube, unwrap UV atlas tự động, gán xương và keyframe animation.
- `mcp/blender/instructions.md`: Thực thi script Python headless với `bpy`, tải asset Polyhaven/Sketchfab.
- `mcp/remotion/instructions.md`: Cấu trúc composition, API tra cứu tài liệu, đồng bộ version.

---

## ⚙️ 6. Cấu Hình Toàn Cục (Global Settings)

File `configs/config.json` định nghĩa các chính sách tự động hóa cấp cao của Antigravity:
```json
{
  "userSettings": {
    "artifactReviewMode": "ARTIFACT_REVIEW_MODE_TURBO",
    "autoExecutionPolicy": "CASCADE_COMMANDS_AUTO_EXECUTION_EAGER",
    "browserJsExecutionPolicy": "BROWSER_JS_EXECUTION_POLICY_TURBO",
    "enableTerminalSandbox": false,
    "globalPermissionGrants": {
      "allow": [
        "mcp(godot-bridge/get_godot_status)",
        "read_url(remotion.dev)"
      ]
    },
    "nonWorkspaceFileAccessPolicy": "AGENT_SETTING_POLICY_ALLOW",
    "queuedMessageDeliveryStrategy": "MESSAGE_DELIVERY_STRATEGY_NEXT_INVOCATION"
  }
}
```

---

## 💻 7. Yêu Cầu Môi Trường (System Prerequisites)

Để các công cụ vận hành trơn tru trên máy tính mục tiêu:
1. **Node.js**: Phiên bản 20+ hoặc 22+ (`node -v` và `npm -v`).
2. **Python & uv**: Python 3.10+ kèm trình quản lý `uv` / `uvx` (`uv --version`).
3. **Godot Engine**: Godot 4.x (Standard 64-bit) được đặt trong PATH hoặc tại `~/.gemini/antigravity/bin/godot.exe`.
4. **Git & GitHub CLI**: `git` và `gh` đã đăng nhập tài khoản.

