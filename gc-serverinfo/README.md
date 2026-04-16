## 📋 Overview
This resource displays a **transparent** server information box in the top-right corner showing:
- Server name and logo (GangCity RP)
- Current player count / Max players
- Player ID
- Current job
- Cash amount
- Bank amount

**Key Feature**: Box is see-through so you can see the game world behind it!

---

## 📦 DEPENDENCIES REQUIRED

### ⚠️ CRITICAL - Install These First:

1. **qb-core** (Required)
   - Used to get player data, job, money
   - Must be started BEFORE gc-serverinfo

2. **No other dependencies needed!**
   - Works standalone

---

## 🔧 Installation Instructions

### Step 1: Copy Resource Folder
```
Copy "gc-serverinfo" folder to:
[your-server]/resources/[standalone]/gc-serverinfo
```
### Step 2: Add Logo
1. Place your `myLogo.png` in the `html` folder
2. Must be named exactly `myLogo.png`
3. Recommended size: 96x96px

### Step 3: Update server.cfg
Add to your server.cfg (order matters!):
```cfg
# Start QBCore first
ensure qb-core
ensure qb-smallresources

# Then start gc-serverinfo
ensure gc-serverinfo

# Other resources after
ensure ps-hud
ensure qb-spawn
```

### Step 4: Restart Server
```
in console
refresh and then start gc-serverinfo
or restart entire server


## 🎨 Customization

### Change Transparency (More or Less)
Edit `html/style.css` line 21:
```css
/* Current: 15% opacity (transparent) */
background: linear-gradient(135deg, rgba(139, 0, 0, 0.15) 0%, rgba(100, 0, 0, 0.12) 100%);

/* More transparent (10%): */
background: linear-gradient(135deg, rgba(139, 0, 0, 0.10) 0%, rgba(100, 0, 0, 0.08) 100%);

/* Less transparent (20%): */
background: linear-gradient(135deg, rgba(139, 0, 0, 0.20) 0%, rgba(100, 0, 0, 0.18) 100%);
```

### Change Colors
Edit `html/style.css`:
```css
/* Red theme (current): */
rgba(139, 0, 0, 0.15)  /* Dark red */

/* Blue theme: */
rgba(0, 0, 139, 0.15)  /* Dark blue */

/* Green theme: */
rgba(0, 139, 0, 0.15)  /* Dark green */

/* Purple theme: */
rgba(139, 0, 139, 0.15)  /* Dark purple */
```

### Change Position
Edit `html/style.css` lines 19-20:
```css
/* Top-right (current): */
top: 20px;
right: 20px;

/* Top-left: */
top: 20px;
left: 20px;

/* Bottom-right: */
bottom: 20px;
right: 20px;
```

### Change Server Name
Edit `html/index.html` lines 16-17:
```html
<div class="server-name">YOUR SERVER NAME</div>
<div class="server-subtitle">Your Tagline</div>
```

---

## 🛠️ Troubleshooting

### Box Not Showing After Spawn
1. Check if qb-core is running: `ensure qb-core`
2. Try spawning with different character
3. Check F8 console for errors
4. Make sure resource is started: `ensure gc-serverinfo`

### Text Hard to Read
1. Increase background opacity in `style.css` (line 21)
2. Increase text shadow in `style.css` (line 144)
3. Or change text color to brighter shade

### Logo Not Showing
1. Verify file is named exactly `myLogo.png`
2. File must be in `html` folder
3. Check if file is valid PNG format
4. Try different image size (200x200px recommended)

---

## 📝 Technical Details

### Spawn Detection
The script listens for these events:
- `QBCore:Client:OnPlayerSpawn` (main trigger)
- `qb-spawn:client:setupSpawns` (backup trigger)

### Update Frequency
- Player info: Every 5 seconds
- Player count: Every 30 seconds
- Money updates: Instant when changed

### Performance
- Very lightweight
- No performance impact
- Uses NUI for display
- Minimal server callbacks

---

## ⚙️ Dependencies Summary

✅ **Required:**
- qb-core

❌ **NOT Required:**
- ps-hud
- Any other HUD
- Additional libraries
- Special dependencies

---

## 📊 Compatibility

✅ **Works With:**
- QBCore Framework
- ps-hud
- Most HUD resources
- Custom spawns
- Character selection screens

❌ **Does NOT Work With:**
- ESX Framework (use qb-core only)
- Non-QBCore servers

**Version: 1.3.0 (Transparent Fix)**
**Created for: Gang City RP**
**Framework: QBCore**
