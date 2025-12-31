# ⚡ Batch Tech: Automated Knowledge Vault

> *"Minimum Effort, Maximum Efficiency."*

## 🛠 Overview
This is a custom-built automation suite for **Nyasha Gabriel / Greyway.Co**. It serves as a high-speed, offline-first indexing engine for educational courses and entertainment. It decouples the *search* process from the *download* process, allowing for instant, zero-latency browsing of thousands of indexed videos.

## 🚀 Core Commands

### 1. `learn "[query]"`
**The Knowledge Engine.**
- **Search:** Fetches metadata from YouTube without downloading video (Instant).
- **Index:** Saves all results to a local SQLite database (`index.db`).
- **Download:**
    - If a **Playlist** is selected: Automatically creates a named course folder (e.g., `downloads/Flutter_Clean_Arch/`).
    - If a **Video** is selected: Downloads high-quality MP4 to the root learning folder.
- **Backup:** Auto-commits metadata changes to Git.

### 2. `chill "[query]"`
**The Entertainment Engine.**
- Operates identically to `learn` but saves content to a dedicated `chill/` directory to keep the workspace clean.
- **Smart Link Detection:** Accepts URLs from Instagram, TikTok, X (Twitter), and YouTube directly.

### 3. `save-tools`
**The Sloth Protocol.**
- Instantly backs up the entire toolset, database, and search history to the `batch-tools` private cloud repository.
- Does **not** upload heavy video files (bandwidth safe).

## ⚙️ Architecture
- **Engine:** `yt-dlp` (Bleeding Edge Binary)
- **Database:** `sqlite3` (Local Metadata Cache)
- **Interface:** `fzf` (Fuzzy Search UI)
- **Parser:** `jq` (JSON Processing)

## 📦 Restoration
To deploy this system on a fresh Linux machine:
\`\`\`bash
git clone git@github.com:gabrielle247l/batch-tools.git ~/batch_tech
cd ~/batch_tech
# Add ./bin to PATH in .bashrc
\`\`\`
