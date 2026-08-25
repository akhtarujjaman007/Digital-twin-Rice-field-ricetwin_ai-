# 🌾 RiceTwin AI
### AI-Enabled Digital Twin Framework for Intelligent Rice Farming Using IoT and Deep Learning

<p align="center">
  <img src="images/banner.png" alt="RiceTwin AI" width="100%">
</p>

## 📖 Overview

RiceTwin AI is an AI-enabled Digital Twin framework designed for intelligent rice farming. The system integrates IoT sensors, ESP32, ESP32-CAM, MQTT communication, a FastAPI backend, an EfficientNetV2B3 deep learning model, SQLite database management, and a Flutter mobile application.

The platform provides:

- 🌱 Real-time environmental monitoring
- 🤖 AI-based rice disease detection
- 🌐 Digital Twin synchronization
- 📊 Environmental risk analysis
- 📱 Flutter mobile application
- 💧 Remote relay-controlled water pump
- 📈 Historical analytics and intelligent recommendations

This project was developed as an academic research project for intelligent precision agriculture.

---

# ✨ Features

- Real-time monitoring of:
  - Temperature
  - Humidity
  - Soil Moisture
  - Soil pH
  - Light Intensity

- ESP32-CAM rice leaf image acquisition

- EfficientNetV2B3 AI disease classification

- Digital Twin visualization

- Environmental risk assessment

- Historical sensor data

- Remote relay-controlled irrigation pump

- Flutter mobile application

---

# 🏗️ System Architecture

<p align="center">
<img src="images/architecture.png" width="95%">
</p>

---

# 🛠️ Hardware Components

- ESP32 Development Board
- ESP32-CAM
- Temperature Sensor
- Humidity Sensor
- Soil Moisture Sensor
- Soil pH Sensor
- Light Intensity Sensor
- Relay Module
- DC Water Pump
- 5V / 12V Power Supply

---

# ⚠️⚠️ Hardware Notice ⚠️⚠️

**The complete hardware architecture has already been designed and implemented.**

However, the version available in this GitHub repository uses **simulation/demo data** for testing and demonstration purposes because continuous field testing hardware is not included in the repository.

Developers or researchers who wish to deploy the system in real agricultural environments can connect actual sensors and hardware by modifying the hardware interface and communication configuration according to their own setup.

The software architecture remains compatible with real hardware deployment.

---

# 🧠 AI Model

Model:
- EfficientNetV2B3 (Transfer Learning)

Dataset:
- Bangladeshi Rice Disease Dataset

Classes:

- Healthy
- Insect
- Leaf Scald
- Rice Blast
- Rice Leaffolder
- Rice Stripes
- Rice Tungro

---

# 📱 Mobile Application

The Flutter application supports:

- Dashboard
- Digital Twin Visualization
- AI Disease Detection
- Historical Analytics
- Environmental Risk
- Water Pump Control
- Intelligent Recommendations

---

# ⚙️ Technology Stack

| Component | Technology |
|------------|------------|
| Mobile App | Flutter |
| Backend | FastAPI |
| AI Framework | TensorFlow |
| AI Model | EfficientNetV2B3 |
| Database | SQLite |
| Communication | MQTT + REST API |
| Hardware | ESP32 + ESP32-CAM |

---

# 🚀 Getting Started

## Clone Repository

```bash
git clone https://github.com/yourusername/RiceTwin-AI.git
```

## Backend

```bash
cd backend

pip install -r requirements.txt

python main.py
```

## Flutter

```bash
flutter pub get

flutter run
```

---

# 📷 Screenshots


---

# 📄 Research Paper

This repository accompanies the research paper:

> **AI-Enabled Digital Twin Framework for Intelligent Rice Farming Using IoT and Deep Learning**

---

# ⚠️ Academic Use Notice

This repository is intended **solely for academic research, educational purposes, and demonstration**.

Commercial use is **not permitted** without prior written permission from the author.

---

# 📜 Copyright & License

© 2026 Sujon Siddiquee. All Rights Reserved.

This project, including its source code, architecture, figures, documentation, models, and design, is protected by copyright.

### Restrictions

Without explicit written permission from the author, you may **NOT**:

- Copy this project or substantial portions of it.
- Modify or create derivative works.
- Redistribute the source code.
- Use the code in commercial or revenue-generating products.
- Publish modified versions.
- Claim this work as your own.

Viewing the source code for learning and academic reference is permitted.

If you wish to use any part of this project in research, publications, commercial products, or other software, please contact the author first.

---

# 👨‍💻 Author

**Md. Akhtarujjaman Siddiquee**

IoT & Robotics Engineering

University of Frontier Technology Bangladesh

GitHub:
https://github.com/akhtarujjaman007

Email:
2001031@iot.uftb.ac.bd
akhtarujjamansiddiquee@gmail.com

The Backend file link : Upcomming
