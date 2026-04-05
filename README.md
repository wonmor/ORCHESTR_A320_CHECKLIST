# ORCHESTR A320 Checklist

A comprehensive, interactive 3D Airbus A320 cockpit reference and checklist app for **iOS**, **macOS**, and **visionOS**.

Built with SwiftUI and SceneKit, featuring an explorable 3D cockpit model with 35+ labeled instrument targets, complete normal/emergency checklists, approach procedure guides, FMGC operations reference, and full POH data.

## Features

### Normal Checklists
Complete flow-through checklists for every phase of flight with interactive check-off tracking and progress indicators:
- Cockpit Preparation
- Before Start / After Start
- Before Taxi / Before Takeoff
- After Takeoff / Climb / Cruise
- Descent Preparation / Approach / Landing
- After Landing / Parking / Securing

### Emergency Procedures
17 emergency and abnormal procedures with memory items, step-by-step actions, and severity classification:
- Engine Fire (Ground & Flight)
- Engine Failure After V1 / Rejected Takeoff
- Dual Engine Failure / Emergency Descent
- Rapid Depressurization / Smoke Removal
- Emergency Evacuation / Ditching
- Unreliable Airspeed / TCAS RA / Windshear Escape
- Fuel Leak / Hydraulic Failure / Electrical Emergency / Loss of Braking

### Instrument Guides
Detailed reference for 10 cockpit instrument systems:
- **PFD** — Primary Flight Display (airspeed tape, attitude, altitude, FMA)
- **ND** — Navigation Display (modes, overlays, range selection)
- **ECAM** — Engine/Warning + System Display (all synoptic pages)
- **FCU** — Flight Control Unit (speed, heading, altitude, VS knobs)
- **MCDU** — Multipurpose Control Display Unit (all pages, color coding)
- **Overhead Panel** — Dark cockpit philosophy, all panel sections
- **Center Pedestal** — Thrust levers, flap lever, MCDU, RMP, transponder
- **Glareshield** — EFIS controls, master warning/caution
- **Autopilot / FD** — All AP modes, flight laws, protections
- **Radio / Comms** — RMP, ACP, transponder

### Approach Procedures
8 approach types with FMGC setup instructions, minimums, and step-by-step procedures:
- ILS (CAT I / II / III with autoland)
- VOR / VOR-DME / NDB
- RNAV (GPS) with LNAV/VNAV/LPV
- Visual / Circling / LOC Only

### FMGC Operations
10 FMGC operation guides with MCDU key-by-key instructions:
- Flight Plan Entry & Performance Setup
- Lateral Navigation (LNAV) & Vertical Navigation (VNAV)
- DIR TO, Holding Patterns, Secondary Flight Plan
- Step Climb/Descent, Cost Index, Wind Entry

### POH Reference
Pilot's Operating Handbook data covering:
- **Limitations** — Speed (VMO/VFE/VLE), weight (MTOW/MLW/MZFW), altitude, engine limits, environmental
- **Weight & Balance** — OEW, CG range, fuel capacities, cargo volumes
- **Performance** — Takeoff distances, cruise data, approach/landing, single engine
- **Systems** — Engines, hydraulics, electrical, flight controls, pressurization, fuel

### 3D Interactive Cockpit
Explorable SceneKit-based A320 cockpit with:
- 35+ labeled instrument targets across all cockpit zones
- Crosshair-based target detection with contextual info panels
- Pan/pinch camera controls with depth of field
- Directional movement (forward, backward, left, right)
- Tap-through to related instrument guide content

## Architecture

```
A320GuideOrch/
  A320GuideOrchApp.swift           # App entry point (multi-platform)
  ContentView.swift                # Shared UI components
  BottomSheetView.swift            # Bottom sheet component
  Platform/
    PlatformAliases.swift          # Cross-platform type aliases
  Models/
    ChecklistModels.swift          # All data models
    A320Database.swift             # Complete A320 content database
  Views/
    MainNavigationView.swift       # Tab (iOS/visionOS) / Sidebar (macOS) navigation
    ChecklistViews.swift           # Normal checklist views
    EmergencyViews.swift           # Emergency procedure views
    InstrumentViews.swift          # Instrument guide views
    ApproachViews.swift            # Approach procedure views
    FMGCViews.swift                # FMGC operation views
    POHViews.swift                 # POH reference views
    CockpitExplorerView.swift      # 3D cockpit (SceneKit, cross-platform)
  Assets/
    a320-cockpit.scn               # SceneKit 3D cockpit scene
    a320-cockpit.usdz              # USDZ model (RealityKit/AR ready)
    a320-plane.obj                 # OBJ reference model
```

## Platform Support

| Platform | Status | Navigation | 3D Engine |
|----------|--------|------------|-----------|
| iOS 17.4+ | Primary | Tab bar | SceneKit (UIViewRepresentable) |
| macOS | Supported | Sidebar | SceneKit (NSViewRepresentable) |
| visionOS | Supported | Tab bar + Volumetric window | SceneKit / RealityKit ready |

## Requirements

- Xcode 15.3+
- iOS 17.4+ / macOS 14+ / visionOS 1.0+
- Swift 5.0+

## Getting Started

1. Clone the repository
2. Open `A320GuideOrch.xcodeproj` in Xcode
3. Select your target device/simulator
4. Build and run

To add macOS or visionOS targets:
1. In Xcode, go to project settings
2. Add a new target for macOS (Mac Catalyst or native) or visionOS
3. Add all Swift files and the `a320-cockpit.scn` asset to the new target
4. Build and run

## Content Disclaimer

This app is designed as a **training and reference tool**. It is NOT a substitute for official airline Standard Operating Procedures (SOPs), the official Airbus FCOM/QRH, or proper type-rating training. Always refer to your operator's approved documentation for actual flight operations.

## License

All rights reserved. For educational and training purposes.
