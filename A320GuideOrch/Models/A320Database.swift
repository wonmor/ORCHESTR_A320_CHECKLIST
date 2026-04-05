import SwiftUI

// MARK: - A320 Complete Database

struct A320Database {

    // MARK: - Normal Checklists

    static let normalChecklists: [Checklist] = [
        cockpitPreparation,
        beforeStart,
        afterStart,
        beforeTaxi,
        beforeTakeoff,
        afterTakeoff,
        climb,
        cruise,
        descentPreparation,
        approachChecklist,
        landingChecklist,
        afterLanding,
        parking,
        securing
    ]

    static let cockpitPreparation = Checklist(
        title: "Cockpit Preparation",
        subtitle: "Initial setup and verification",
        icon: "wrench.and.screwdriver",
        phase: .preflight,
        items: [
            ChecklistItem(challenge: "PARKING BRAKE", response: "ON", notes: "Verify parking brake handle is pulled"),
            ChecklistItem(challenge: "GEAR PINS & COVERS", response: "REMOVED / STOWED", notes: "Confirm all gear pins removed and stowed in cockpit"),
            ChecklistItem(challenge: "ADIRS", response: "NAV", notes: "Set all 3 ADIRS to NAV position"),
            ChecklistItem(challenge: "FUEL QUANTITY", response: "___KG / CHECKED", notes: "Compare actual fuel with dispatch release"),
            ChecklistItem(challenge: "SEAT BELTS", response: "ON", notes: "Seat belt sign ON"),
            ChecklistItem(challenge: "NO SMOKING", response: "ON (AUTO)", notes: "No smoking sign ON or AUTO"),
            ChecklistItem(challenge: "BARO REF", response: "___SET (BOTH)", notes: "Set QNH on both PFDs and standby altimeter"),
            ChecklistItem(challenge: "EMERGENCY EQUIPMENT", response: "CHECKED", notes: "PBE, fire extinguisher, crash axe, flashlight"),
            ChecklistItem(challenge: "SLIDING WINDOWS", response: "LOCKED", notes: "Both cockpit sliding windows locked"),
            ChecklistItem(challenge: "OXYGEN", response: "TESTED / 100%", notes: "Test crew oxygen masks, check pressure"),
            ChecklistItem(challenge: "RAIN REPELLENT", response: "CHECKED", notes: "Check rain repellent quantity"),
            ChecklistItem(challenge: "WINDSHIELD HEAT", response: "ON", notes: "Both windshield heat switches ON"),
            ChecklistItem(challenge: "EXTERIOR LIGHTS", response: "AS REQUIRED", notes: "NAV lights ON, beacon OFF until engine start"),
            ChecklistItem(challenge: "ACARS / DATALINK", response: "INITIALIZED", notes: "Enter flight number and verify ATIS"),
        ],
        color: .blue
    )

    static let beforeStart = Checklist(
        title: "Before Start",
        subtitle: "Pre-engine start checks",
        icon: "engine.combustion",
        phase: .preflight,
        items: [
            ChecklistItem(challenge: "COCKPIT PREPARATION", response: "COMPLETED (BOTH)", notes: "Both pilots confirm cockpit prep complete"),
            ChecklistItem(challenge: "SIGNS", response: "ON / AUTO", notes: "Seat belt ON, No smoking AUTO"),
            ChecklistItem(challenge: "THRUST LEVERS", response: "IDLE", notes: "Both thrust levers at IDLE"),
            ChecklistItem(challenge: "PARKING BRAKE", response: "ON", notes: "Confirm parking brake set"),
            ChecklistItem(challenge: "WINDOWS / DOORS", response: "CLOSED / ARMED", notes: "All doors closed, slides armed (verify ECAM DOOR page)"),
            ChecklistItem(challenge: "BEACON", response: "ON", notes: "Anti-collision beacon ON (signal to ground crew)"),
            ChecklistItem(challenge: "T.O. DATA", response: "SET / CONFIRMED", notes: "V1, VR, V2 entered and crosschecked"),
            ChecklistItem(challenge: "MCDU PERF / W&B", response: "CHECKED", notes: "Verify PERF TO page, flex temp, weight/CG"),
            ChecklistItem(challenge: "ECAM MEMO", response: "T.O. NO BLUE", notes: "Verify all T.O. memo items have no blue"),
            ChecklistItem(challenge: "ATC CLEARANCE", response: "RECEIVED / SET", notes: "Clearance received, initial altitude set on FCU"),
        ],
        color: .blue
    )

    static let afterStart = Checklist(
        title: "After Start",
        subtitle: "Post-engine start verification",
        icon: "checkmark.circle",
        phase: .preflight,
        items: [
            ChecklistItem(challenge: "ANTI ICE", response: "AS REQUIRED", notes: "Engine and wing anti-ice as required by conditions"),
            ChecklistItem(challenge: "ECAM STATUS", response: "CHECKED", notes: "Review ECAM status page, clear any messages"),
            ChecklistItem(challenge: "PITCH TRIM", response: "___SET", notes: "Set per loadsheet CG, verify green band"),
            ChecklistItem(challenge: "RUDDER TRIM", response: "ZERO", notes: "Rudder trim set to zero"),
            ChecklistItem(challenge: "FLIGHT CONTROLS", response: "CHECKED (BOTH)", notes: "Full deflection of all flight controls, verify ECAM"),
            ChecklistItem(challenge: "GROUND SPOILERS", response: "ARMED", notes: "Arm ground spoilers"),
            ChecklistItem(challenge: "FLAPS", response: "___SET (T.O. CONFIG)", notes: "Set takeoff flap setting as per performance calc"),
            ChecklistItem(challenge: "ATC / TRANSPONDER", response: "SET", notes: "Squawk assigned code, transponder to AUTO or STBY"),
        ],
        color: .cyan
    )

    static let beforeTaxi = Checklist(
        title: "Before Taxi",
        subtitle: "Pre-taxi verification",
        icon: "road.lanes",
        phase: .taxi,
        items: [
            ChecklistItem(challenge: "FLIGHT INSTRUMENTS", response: "CHECKED (BOTH)", notes: "PFD/ND showing correct data, compare both sides"),
            ChecklistItem(challenge: "BRIEFING", response: "CONFIRMED", notes: "Departure briefing complete"),
            ChecklistItem(challenge: "FLAP LEVER", response: "___SET (T.O. CONFIG)", notes: "Flaps set for takeoff"),
            ChecklistItem(challenge: "RADAR & PREDICTIVE W/S", response: "ON", notes: "Weather radar ON, PWS system active"),
            ChecklistItem(challenge: "NOSE LIGHT", response: "TAXI", notes: "Nose gear light to TAXI"),
            ChecklistItem(challenge: "RUNWAY TURNOFF LIGHTS", response: "ON", notes: "Both runway turnoff lights ON"),
            ChecklistItem(challenge: "ATC CLEARANCE", response: "CONFIRMED", notes: "Taxi clearance received"),
        ],
        color: .cyan
    )

    static let beforeTakeoff = Checklist(
        title: "Before Takeoff",
        subtitle: "Final checks before departure",
        icon: "airplane.departure",
        phase: .takeoff,
        items: [
            ChecklistItem(challenge: "T.O. CONFIG", response: "TEST — NORMAL", notes: "Press T.O. CONFIG button, verify no warning"),
            ChecklistItem(challenge: "CABIN", response: "READY", notes: "Cabin crew confirms ready for departure"),
            ChecklistItem(challenge: "TCAS", response: "TA/RA", notes: "TCAS mode set to TA/RA"),
            ChecklistItem(challenge: "ENGINE MODE SELECTOR", response: "AS REQUIRED", notes: "NORM or IGN/START (for adverse weather)"),
            ChecklistItem(challenge: "PACKS", response: "AS REQUIRED", notes: "ON for normal ops, consider OFF for performance limited T.O."),
            ChecklistItem(challenge: "STROBE LIGHTS", response: "ON / AUTO", notes: "Strobe lights ON or AUTO"),
            ChecklistItem(challenge: "LANDING LIGHTS", response: "ON", notes: "All landing lights ON"),
            ChecklistItem(challenge: "TRANSPONDER", response: "ON / TA-RA", notes: "Transponder to ON (or AUTO) and TCAS to TA/RA"),
            ChecklistItem(challenge: "ECAM MEMO", response: "T.O. NO BLUE", notes: "Final verification of T.O. memo — no blue items"),
        ],
        color: .green
    )

    static let afterTakeoff = Checklist(
        title: "After Takeoff / Climb",
        subtitle: "Post-departure transition",
        icon: "arrow.up.right",
        phase: .climb,
        items: [
            ChecklistItem(challenge: "LANDING GEAR", response: "UP", notes: "Gear UP confirmed on ECAM"),
            ChecklistItem(challenge: "FLAPS", response: "RETRACTED", notes: "Retract flaps on schedule per SRS/speed"),
            ChecklistItem(challenge: "GROUND SPOILERS", response: "DISARMED", notes: "Verify ground spoilers disarmed"),
            ChecklistItem(challenge: "PACKS", response: "ON (IF OFF)", notes: "Return packs to ON if turned off for takeoff"),
            ChecklistItem(challenge: "APU", response: "OFF (IF RUNNING)", notes: "APU master OFF if not needed"),
            ChecklistItem(challenge: "BARO REF", response: "TRANSITION — SET STD", notes: "Set STD (1013) passing transition altitude"),
            ChecklistItem(challenge: "EXTERIOR LIGHTS", response: "AS REQUIRED", notes: "Landing lights OFF above 10,000ft / turn off below if desired"),
            ChecklistItem(challenge: "EFIS MODE", response: "AS REQUIRED", notes: "Select appropriate ND range and mode"),
        ],
        color: .mint
    )

    static let climb = Checklist(
        title: "Climb",
        subtitle: "Climb phase management",
        icon: "arrow.up.forward",
        phase: .climb,
        items: [
            ChecklistItem(challenge: "ALTIMETERS", response: "STD SET / CROSSCHECKED", notes: "Both set to 1013 above transition altitude"),
            ChecklistItem(challenge: "RADAR", response: "AS REQUIRED", notes: "Adjust tilt and gain for weather avoidance"),
            ChecklistItem(challenge: "FUEL", response: "CHECKED", notes: "Compare actual vs planned fuel burn"),
            ChecklistItem(challenge: "ECAM", response: "CHECKED", notes: "Review systems, no abnormal indications"),
            ChecklistItem(challenge: "NAVAIDS", response: "CHECKED", notes: "Verify nav accuracy, cross-check FMGC position"),
        ],
        color: .mint
    )

    static let cruise = Checklist(
        title: "Cruise",
        subtitle: "Enroute monitoring",
        icon: "airplane",
        phase: .cruise,
        items: [
            ChecklistItem(challenge: "FUEL MANAGEMENT", response: "MONITORED", notes: "Monitor fuel burn vs flight plan, check balance"),
            ChecklistItem(challenge: "FLIGHT PROGRESS", response: "CHECKED", notes: "Verify ETAs, waypoints, wind data"),
            ChecklistItem(challenge: "NAVAIDS / GPS", response: "CROSSCHECKED", notes: "Verify FMGC position accuracy"),
            ChecklistItem(challenge: "WEATHER", response: "UPDATED", notes: "Check METAR/TAF for destination and alternates"),
            ChecklistItem(challenge: "CABIN TEMP / PRESSURE", response: "CHECKED", notes: "Verify cabin altitude and differential pressure"),
            ChecklistItem(challenge: "ECAM STATUS", response: "REVIEWED", notes: "Periodic systems check"),
            ChecklistItem(challenge: "STEP CLIMB", response: "AS REQUIRED", notes: "Consider optimum altitude as weight decreases"),
        ],
        color: .indigo
    )

    static let descentPreparation = Checklist(
        title: "Descent Preparation",
        subtitle: "Planning for arrival",
        icon: "arrow.down.right",
        phase: .descent,
        items: [
            ChecklistItem(challenge: "ATIS / WEATHER", response: "OBTAINED", notes: "Get destination ATIS, check weather and NOTAMs"),
            ChecklistItem(challenge: "ARRIVAL BRIEFING", response: "COMPLETED", notes: "Brief STAR, approach, missed approach, alternates"),
            ChecklistItem(challenge: "MCDU", response: "ARRIVAL ENTERED", notes: "Enter STAR, approach, constraints in FMGC"),
            ChecklistItem(challenge: "LANDING ELEVATION", response: "___SET", notes: "Set landing elevation on MCDU PERF APPR page"),
            ChecklistItem(challenge: "MINIMUM", response: "___SET", notes: "Set DH/MDA on PERF APPR page and FCU"),
            ChecklistItem(challenge: "AUTOBRAKE", response: "___SET", notes: "Set as required (MED for normal, MAX for short/contaminated)"),
            ChecklistItem(challenge: "FUEL", response: "CHECKED", notes: "Verify fuel sufficient for approach, missed approach, alternate"),
            ChecklistItem(challenge: "ECAM STATUS", response: "CHECKED", notes: "Review any inoperative systems affecting approach"),
            ChecklistItem(challenge: "RADIOS / NAVAIDS", response: "SET", notes: "Set appropriate ILS/VOR frequencies, verify ident"),
        ],
        color: .orange
    )

    static let approachChecklist = Checklist(
        title: "Approach",
        subtitle: "Final approach configuration",
        icon: "scope",
        phase: .approach,
        items: [
            ChecklistItem(challenge: "BARO REF", response: "___SET (BOTH)", notes: "Set QNH below transition level, crosscheck"),
            ChecklistItem(challenge: "SEAT BELTS", response: "ON", notes: "Seat belt sign ON for cabin"),
            ChecklistItem(challenge: "MINIMUM", response: "___SET (BOTH)", notes: "DH or MDA set and confirmed on both PFDs"),
            ChecklistItem(challenge: "AUTOBRAKE", response: "___SET", notes: "Confirm autobrake setting"),
            ChecklistItem(challenge: "ENGINE MODE SELECTOR", response: "AS REQUIRED", notes: "NORM or IGN for adverse conditions"),
            ChecklistItem(challenge: "LANDING LIGHTS", response: "ON", notes: "All landing lights ON below 10,000ft"),
            ChecklistItem(challenge: "ECAM MEMO", response: "LDG NO BLUE", notes: "All landing memo items completed"),
            ChecklistItem(challenge: "GO-AROUND ALTITUDE", response: "___SET", notes: "Set missed approach altitude on FCU"),
        ],
        color: .yellow
    )

    static let landingChecklist = Checklist(
        title: "Landing",
        subtitle: "Final landing configuration",
        icon: "airplane.arrival",
        phase: .landing,
        items: [
            ChecklistItem(challenge: "CABIN", response: "SECURED", notes: "Cabin crew confirms cabin secured for landing"),
            ChecklistItem(challenge: "GEAR", response: "DOWN — 3 GREEN", notes: "Landing gear down, 3 green indications on ECAM"),
            ChecklistItem(challenge: "FLAPS", response: "FULL / CONF 3", notes: "Flaps FULL (or CONF 3 if required), verify on ECAM"),
            ChecklistItem(challenge: "GROUND SPOILERS", response: "ARMED", notes: "Ground spoilers armed, verify on ECAM"),
            ChecklistItem(challenge: "AUTOBRAKE", response: "CONFIRMED", notes: "Autobrake armed and set"),
            ChecklistItem(challenge: "ECAM MEMO", response: "LDG NO BLUE", notes: "Final check — all landing items done"),
        ],
        color: .red
    )

    static let afterLanding = Checklist(
        title: "After Landing",
        subtitle: "Post-touchdown procedures",
        icon: "road.lanes",
        phase: .postFlight,
        items: [
            ChecklistItem(challenge: "GROUND SPOILERS", response: "DISARMED", notes: "Verify ground spoilers retracted and disarmed"),
            ChecklistItem(challenge: "FLAPS", response: "RETRACTED", notes: "Flaps to 0"),
            ChecklistItem(challenge: "STROBE LIGHTS", response: "OFF / AUTO", notes: "Strobe lights OFF"),
            ChecklistItem(challenge: "LANDING LIGHTS", response: "OFF", notes: "Landing lights OFF"),
            ChecklistItem(challenge: "NOSE LIGHT", response: "TAXI", notes: "Nose gear light to TAXI"),
            ChecklistItem(challenge: "RUNWAY TURNOFF LIGHTS", response: "ON", notes: "Runway turnoff lights ON for taxi"),
            ChecklistItem(challenge: "RADAR & PWS", response: "OFF", notes: "Weather radar and predictive windshear OFF"),
            ChecklistItem(challenge: "APU", response: "START (IF REQUIRED)", notes: "Start APU for ground operations"),
            ChecklistItem(challenge: "TRANSPONDER", response: "STBY", notes: "Transponder to standby once clear of runway"),
        ],
        color: .purple
    )

    static let parking = Checklist(
        title: "Parking / Shutdown",
        subtitle: "Engine shutdown and securing",
        icon: "parkingsign",
        phase: .postFlight,
        items: [
            ChecklistItem(challenge: "PARKING BRAKE / CHOCKS", response: "ON / CHOCKS IN PLACE", notes: "Set parking brake OR confirm chocks"),
            ChecklistItem(challenge: "ENGINES", response: "OFF", notes: "Both engine master switches OFF"),
            ChecklistItem(challenge: "SEAT BELTS", response: "OFF", notes: "Seat belt sign OFF"),
            ChecklistItem(challenge: "EXTERIOR LIGHTS", response: "AS REQUIRED", notes: "NAV lights ON, all others off"),
            ChecklistItem(challenge: "FUEL PUMPS", response: "OFF", notes: "All fuel pump switches OFF"),
            ChecklistItem(challenge: "PROBE/WINDOW HEAT", response: "OFF", notes: "All probe and window heat OFF"),
            ChecklistItem(challenge: "APU BLEED", response: "ON (IF APU RUNNING)", notes: "APU bleed ON if APU supplying air"),
            ChecklistItem(challenge: "ECAM STATUS", response: "NOTED", notes: "Note any defects/faults for maintenance"),
        ],
        color: .purple
    )

    static let securing = Checklist(
        title: "Securing the Aircraft",
        subtitle: "Final shutdown procedures",
        icon: "lock.shield",
        phase: .postFlight,
        items: [
            ChecklistItem(challenge: "ADIRS", response: "OFF", notes: "All 3 ADIRS to OFF"),
            ChecklistItem(challenge: "OXYGEN", response: "OFF", notes: "Crew oxygen OFF"),
            ChecklistItem(challenge: "APU", response: "OFF", notes: "APU master OFF (or leave running per airline SOP)"),
            ChecklistItem(challenge: "EMERGENCY LIGHTS", response: "OFF", notes: "Emergency exit lights OFF"),
            ChecklistItem(challenge: "NO SMOKING / SEAT BELTS", response: "OFF", notes: "Both signs OFF"),
            ChecklistItem(challenge: "ALL BATTERIES", response: "OFF", notes: "BAT 1 and BAT 2 OFF"),
            ChecklistItem(challenge: "GEAR PINS", response: "INSTALLED (IF REQUIRED)", notes: "Install gear pins if aircraft will be towed"),
        ],
        color: .gray
    )

    // MARK: - Emergency Procedures

    static let emergencyProcedures: [EmergencyProcedure] = [
        engineFireGround,
        engineFireFlight,
        engineFailureAfterV1,
        rejectedTakeoff,
        dualEngineFailure,
        emergencyDescent,
        rapidDepressurization,
        smokeRemoval,
        emergencyEvacuation,
        unreliableAirspeed,
        tcasRA,
        windshearEscape,
        ditching,
        fuelLeak,
        hydraulicFailure,
        electricalEmergency,
        lossOfBraking
    ]

    static let engineFireGround = EmergencyProcedure(
        title: "Engine Fire on Ground",
        subtitle: "Fire detected during start or ground ops",
        severity: .warning,
        icon: "flame.fill",
        memoryItems: [
            "PARKING BRAKE — SET",
            "ATC — NOTIFY",
            "AFFECTED ENGINE MASTER — OFF",
            "AFFECTED ENGINE FIRE P/B — PUSH (when ENG MASTER OFF confirmation)",
            "AGENT 1 — DISCHARGE",
        ],
        steps: [
            ProcedureStep(action: "PARKING BRAKE", detail: "SET"),
            ProcedureStep(action: "ATC", detail: "NOTIFY TOWER / GROUND"),
            ProcedureStep(action: "Affected ENGINE MASTER switch", detail: "OFF"),
            ProcedureStep(action: "Affected ENGINE FIRE P/B", detail: "PUSH (guarded, red illuminated)"),
            ProcedureStep(action: "AGENT 1 discharge", detail: "PUSH and hold for 1 second"),
            ProcedureStep(action: "Wait 30 seconds", detail: "Monitor ECAM for fire indication"),
            ProcedureStep(action: "If fire persists: AGENT 2", detail: "DISCHARGE"),
            ProcedureStep(action: "If fire persists after Agent 2", detail: "ORDER EVACUATION"),
            ProcedureStep(action: "CABIN CREW", detail: "ALERT via PA or evacuation horn"),
            ProcedureStep(action: "ALL ENGINES", detail: "MASTER OFF if evacuating"),
            ProcedureStep(action: "PARKING BRAKE", detail: "Verify SET"),
            ProcedureStep(action: "ATC", detail: "Confirm emergency services responding"),
        ],
        notes: [
            "Do not attempt to restart a fire-damaged engine",
            "Coordinate with cabin crew — fire side evacuation must be avoided",
            "If fire continues after both agents, EVACUATE immediately",
        ]
    )

    static let engineFireFlight = EmergencyProcedure(
        title: "Engine Fire in Flight",
        subtitle: "ECAM ENG FIRE warning airborne",
        severity: .warning,
        icon: "flame.fill",
        memoryItems: [
            "AUTOTHRUST — OFF",
            "AFFECTED ENGINE THRUST LEVER — IDLE",
            "AFFECTED ENGINE MASTER — OFF",
            "AFFECTED ENGINE FIRE P/B — PUSH",
        ],
        steps: [
            ProcedureStep(action: "AUTOTHRUST", detail: "OFF"),
            ProcedureStep(action: "Affected ENGINE THRUST LEVER", detail: "IDLE"),
            ProcedureStep(action: "Affected ENGINE MASTER", detail: "OFF"),
            ProcedureStep(action: "Affected ENGINE FIRE P/B", detail: "PUSH"),
            ProcedureStep(action: "AGENT 1", detail: "DISCHARGE after 10 seconds"),
            ProcedureStep(action: "ECAM ACTIONS", detail: "COMPLETE as displayed"),
            ProcedureStep(action: "If fire warning persists after 30 sec", detail: "AGENT 2 — DISCHARGE"),
            ProcedureStep(action: "If fire warning persists", detail: "LAND ASAP at nearest suitable airport"),
            ProcedureStep(action: "ATC", detail: "DECLARE MAYDAY, request vectors to nearest airport"),
            ProcedureStep(action: "CABIN CREW", detail: "BRIEF for possible emergency landing"),
        ],
        notes: [
            "Single engine approach and landing: maintain VAPP + 5kt minimum",
            "Expect asymmetric thrust — be prepared for yaw control",
            "Consider overweight landing if required — safety takes priority over weight limit",
        ]
    )

    static let engineFailureAfterV1 = EmergencyProcedure(
        title: "Engine Failure After V1",
        subtitle: "Continue takeoff with engine failure",
        severity: .warning,
        icon: "exclamationmark.engine.fill",
        memoryItems: [
            "CONTINUE TAKEOFF",
            "At VR — ROTATE normally",
            "Follow SRS flight director",
            "At positive rate — GEAR UP",
        ],
        steps: [
            ProcedureStep(action: "CONTINUE TAKEOFF", detail: "Maintain runway heading"),
            ProcedureStep(action: "At VR", detail: "ROTATE at normal rate"),
            ProcedureStep(action: "Follow SRS FD bars", detail: "Maintain V2 or V2+10"),
            ProcedureStep(action: "Positive rate of climb", detail: "GEAR UP"),
            ProcedureStep(action: "At acceleration altitude", detail: "Reduce pitch, accelerate to green dot"),
            ProcedureStep(action: "Follow ECAM actions", detail: "Affected engine MASTER OFF when safe altitude reached"),
            ProcedureStep(action: "Clean up aircraft", detail: "Retract flaps on schedule"),
            ProcedureStep(action: "ATC", detail: "DECLARE emergency, request vectors for return"),
            ProcedureStep(action: "BRIEF", detail: "Single engine approach briefing"),
        ],
        notes: [
            "DO NOT attempt to identify failed engine until safely airborne",
            "SRS mode provides correct pitch guidance to maintain V2",
            "Use rudder to maintain directional control",
            "Maximum demonstrated crosswind for single engine: varies by operator",
        ]
    )

    static let rejectedTakeoff = EmergencyProcedure(
        title: "Rejected Takeoff (Before V1)",
        subtitle: "Abort takeoff procedure",
        severity: .warning,
        icon: "xmark.octagon.fill",
        memoryItems: [
            "THRUST LEVERS — IDLE",
            "REVERSE THRUST — MAX",
            "BRAKES — MAX (if autobrake insufficient)",
            "ATC — NOTIFY",
        ],
        steps: [
            ProcedureStep(action: "THRUST LEVERS", detail: "IDLE simultaneously"),
            ProcedureStep(action: "REVERSE THRUST", detail: "MAX REVERSE"),
            ProcedureStep(action: "BRAKES", detail: "Apply MAX braking if needed"),
            ProcedureStep(action: "Ground spoilers", detail: "Verify DEPLOYED automatically"),
            ProcedureStep(action: "Once stopped", detail: "Assess situation (fire, engine failure, tire burst)"),
            ProcedureStep(action: "ATC", detail: "NOTIFY of rejected takeoff"),
            ProcedureStep(action: "CLEAR RUNWAY", detail: "If safe and able — taxi clear"),
            ProcedureStep(action: "If unable to clear or fire/smoke", detail: "EVACUATE if necessary"),
            ProcedureStep(action: "BRAKES", detail: "Allow cooling time — HOT BRAKES possible"),
        ],
        notes: [
            "Decision to reject must be made BEFORE V1",
            "Above 100kt, reject only for: engine failure, fire, predictive windshear, aircraft unsafe to fly",
            "After RTO above 100kt: wait for brake cooling before taxi",
            "Hot brakes: keep parking brake OFF, use chocks, keep clear of tires",
        ]
    )

    static let dualEngineFailure = EmergencyProcedure(
        title: "Dual Engine Failure",
        subtitle: "Loss of all engine thrust",
        severity: .warning,
        icon: "exclamationmark.triangle.fill",
        memoryItems: [
            "AIRSPEED — GREEN DOT (or best glide)",
            "APU — START (if below 25,000ft)",
            "MAYDAY — DECLARE",
            "RELIGHT — ATTEMPT",
        ],
        steps: [
            ProcedureStep(action: "AIRSPEED", detail: "Maintain GREEN DOT speed"),
            ProcedureStep(action: "APU", detail: "START (available up to 25,000ft)"),
            ProcedureStep(action: "ATC", detail: "DECLARE MAYDAY — request vectors to nearest airport"),
            ProcedureStep(action: "ENGINE MODE selector", detail: "IGN/START"),
            ProcedureStep(action: "ENGINE RELIGHT", detail: "Attempt windmill relight above 300kt or starter assisted below"),
            ProcedureStep(action: "If no relight at altitude", detail: "Plan for forced landing"),
            ProcedureStep(action: "RAT", detail: "Deploys automatically at low speed / verify extended"),
            ProcedureStep(action: "DITCH / FORCED LANDING", detail: "If no relight achieved — follow ditching procedure"),
            ProcedureStep(action: "CABIN", detail: "BRIEF cabin crew for emergency landing"),
        ],
        notes: [
            "Glide ratio approximately 17:1 (clean config)",
            "At FL350: approximately 150nm glide range",
            "APU provides electrical + bleed air",
            "Windmill relight: N2 > 12% (typically above 300kt)",
            "Consider fuel contamination, volcanic ash as cause",
        ]
    )

    static let emergencyDescent = EmergencyProcedure(
        title: "Emergency Descent",
        subtitle: "Rapid descent to safe altitude",
        severity: .warning,
        icon: "arrow.down.to.line",
        memoryItems: [
            "OXYGEN MASKS — ON (100%)",
            "CREW COMMUNICATION — ESTABLISH",
            "SPEED BRAKES — FULL",
            "DESCEND — MAX RATE to safe altitude",
        ],
        steps: [
            ProcedureStep(action: "OXYGEN MASKS", detail: "ON, 100%, EMER if required"),
            ProcedureStep(action: "CREW COMMUNICATION", detail: "ESTABLISH (use interphone)"),
            ProcedureStep(action: "ATC", detail: "DECLARE MAYDAY, squawk 7700"),
            ProcedureStep(action: "SPEED BRAKES", detail: "FULL EXTENSION"),
            ProcedureStep(action: "AUTOPILOT", detail: "Use OP DES mode or disconnect and pitch for VMO/MMO"),
            ProcedureStep(action: "THRUST LEVERS", detail: "IDLE"),
            ProcedureStep(action: "TARGET ALTITUDE", detail: "Set 10,000ft (or MEA/MSA if higher)"),
            ProcedureStep(action: "PAX SIGNS", detail: "Seat belt ON"),
            ProcedureStep(action: "At safe altitude", detail: "Level off, retract speed brakes"),
            ProcedureStep(action: "CABIN ALTITUDE", detail: "VERIFY below 14,000ft"),
            ProcedureStep(action: "ASSESS", detail: "Plan diversion or continue to destination"),
        ],
        notes: [
            "Typical descent rate: 6,000+ fpm",
            "Above FL250: supplemental oxygen required for passengers after 10 min",
            "Passenger oxygen: approximately 12-22 minutes of supply",
            "Do not exceed VMO/MMO during descent",
        ]
    )

    static let rapidDepressurization = EmergencyProcedure(
        title: "Rapid Depressurization",
        subtitle: "Cabin altitude warning / loss of pressure",
        severity: .warning,
        icon: "wind",
        memoryItems: [
            "OXYGEN MASKS — ON (100%)",
            "CREW COMMUNICATION — ESTABLISH",
            "EMERGENCY DESCENT — INITIATE",
        ],
        steps: [
            ProcedureStep(action: "OXYGEN MASKS", detail: "DON immediately, 100%, select EMER if needed"),
            ProcedureStep(action: "CREW COMMUNICATION", detail: "ESTABLISH via interphone"),
            ProcedureStep(action: "EMERGENCY DESCENT", detail: "INITIATE (see Emergency Descent procedure)"),
            ProcedureStep(action: "PAX OXYGEN MASKS", detail: "Verify DEPLOYED (check ECAM DOOR/OXY page)"),
            ProcedureStep(action: "SEAT BELT SIGNS", detail: "ON"),
            ProcedureStep(action: "CABIN CREW", detail: "NOTIFY via interphone if possible"),
            ProcedureStep(action: "ATC", detail: "MAYDAY, squawk 7700, request lower altitude"),
            ProcedureStep(action: "At safe altitude (10,000ft or MSA)", detail: "LEVEL OFF"),
            ProcedureStep(action: "ECAM ACTIONS", detail: "FOLLOW as displayed"),
            ProcedureStep(action: "ASSESS", detail: "Check cabin integrity, plan diversion"),
        ],
        notes: [
            "Time of useful consciousness at FL350: 30-60 seconds",
            "Time of useful consciousness at FL250: 3-5 minutes",
            "Chemical passenger oxygen generators last approx 12-22 min",
            "If structural damage suspected, reduce speed to minimize further damage",
        ]
    )

    static let smokeRemoval = EmergencyProcedure(
        title: "Smoke / Fumes Removal",
        subtitle: "Smoke or fumes detected in cockpit/cabin",
        severity: .warning,
        icon: "smoke.fill",
        memoryItems: [
            "OXYGEN MASKS — ON (100%)",
            "CREW COMMUNICATION — ESTABLISH",
            "SMOKE GOGGLES — ON",
        ],
        steps: [
            ProcedureStep(action: "OXYGEN MASKS", detail: "ON, 100%, EMER (press-to-test for smoke goggles seal)"),
            ProcedureStep(action: "SMOKE GOGGLES", detail: "ON (if visible smoke)"),
            ProcedureStep(action: "CREW COMMUNICATION", detail: "ESTABLISH via interphone"),
            ProcedureStep(action: "ECAM ACTIONS", detail: "FOLLOW SMOKE/FUMES procedure"),
            ProcedureStep(action: "IDENTIFY SOURCE", detail: "Check circuit breakers, overhead panel, avionics"),
            ProcedureStep(action: "If electrical source suspected", detail: "GALLEY — OFF, commercial load OFF as needed"),
            ProcedureStep(action: "CAB FANS", detail: "OFF"),
            ProcedureStep(action: "If smoke persists", detail: "Consider bleed air configuration changes"),
            ProcedureStep(action: "VENTILATION", detail: "BLOWER and EXTRACT — OVRD"),
            ProcedureStep(action: "CABIN CREW", detail: "Use PBE and extinguishers if fire located"),
            ProcedureStep(action: "PLAN", detail: "LAND ASAP — divert to nearest suitable airport"),
        ],
        notes: [
            "Smoke/fumes may indicate hidden fire — LAND ASAP",
            "If source is identified and isolated, reassess diversion urgency",
            "Cockpit/cabin separation: close cockpit door to prevent smoke spread",
            "PBE (Protective Breathing Equipment) provides approx 15 min protection",
        ]
    )

    static let emergencyEvacuation = EmergencyProcedure(
        title: "Emergency Evacuation",
        subtitle: "Passenger and crew evacuation",
        severity: .warning,
        icon: "figure.run",
        memoryItems: [
            "PARKING BRAKE — SET",
            "ALL ENGINES — OFF",
            "EVACUATION COMMAND — GIVE",
        ],
        steps: [
            ProcedureStep(action: "PARKING BRAKE", detail: "SET"),
            ProcedureStep(action: "ALL ENGINE MASTERS", detail: "OFF"),
            ProcedureStep(action: "ENGINE FIRE P/Bs", detail: "PUSH (both, as precaution)"),
            ProcedureStep(action: "EVACUATION COMMAND", detail: "ON (evacuation horn)"),
            ProcedureStep(action: "ATC", detail: "NOTIFY — request emergency services"),
            ProcedureStep(action: "PA ANNOUNCEMENT", detail: "'EVACUATE, EVACUATE, EVACUATE'"),
            ProcedureStep(action: "APU FIRE P/B", detail: "PUSH"),
            ProcedureStep(action: "ALL BATTERIES", detail: "OFF (after evacuation command given)"),
            ProcedureStep(action: "CREW", detail: "EVACUATE — take emergency equipment"),
            ProcedureStep(action: "ASSEMBLY POINT", detail: "Direct passengers upwind, away from aircraft"),
        ],
        notes: [
            "Slides deploy automatically when doors opened in ARMED mode",
            "Block exits on the fire side — do NOT open",
            "Target: complete evacuation within 90 seconds",
            "Take flight deck quick reference handbook if time permits",
        ]
    )

    static let unreliableAirspeed = EmergencyProcedure(
        title: "Unreliable Airspeed",
        subtitle: "ADR disagree / airspeed discrepancy",
        severity: .caution,
        icon: "speedometer",
        memoryItems: [
            "PITCH — Set memory attitude + thrust",
            "Do NOT chase airspeed indications",
        ],
        steps: [
            ProcedureStep(action: "AUTOPILOT", detail: "OFF"),
            ProcedureStep(action: "AUTOTHRUST", detail: "OFF"),
            ProcedureStep(action: "FLIGHT DIRECTORS", detail: "OFF (both)"),
            ProcedureStep(action: "PITCH ATTITUDE (reference)", detail: "Set per phase:"),
            ProcedureStep(action: "  Takeoff / Go-Around (TOGA)", detail: "15° pitch, landing gear up, flaps as set"),
            ProcedureStep(action: "  Climb (Green Dot)", detail: "10° pitch, clean configuration"),
            ProcedureStep(action: "  Cruise", detail: "5° pitch (or as required for level flight)"),
            ProcedureStep(action: "  Descent / Approach", detail: "0° to -2° pitch, gear & flaps as required"),
            ProcedureStep(action: "THRUST (reference)", detail: "Set N1 per QRH table for weight/altitude"),
            ProcedureStep(action: "CROSSCHECK", detail: "GPS groundspeed, standby instruments, ATC"),
            ProcedureStep(action: "IDENTIFY faulty ADR", detail: "Compare 3 ADRs, switch off disagree ADR"),
            ProcedureStep(action: "If identified", detail: "ADR [x] — OFF, resume normal operation"),
        ],
        notes: [
            "Common causes: pitot icing, pitot blockage, bird strike, volcanic ash",
            "Memory pitch + thrust = safe flight until airspeed sorted out",
            "GPS groundspeed can confirm approximate airspeed (accounting for wind)",
            "Standby airspeed indicator has independent pitot source",
            "Do NOT use ALPHA FLOOR / ALPHA PROT for speed reference when ADRs unreliable",
        ]
    )

    static let tcasRA = EmergencyProcedure(
        title: "TCAS Resolution Advisory",
        subtitle: "TCAS RA — traffic conflict resolution",
        severity: .warning,
        icon: "airplane.circle.fill",
        memoryItems: [
            "FOLLOW RA commands IMMEDIATELY",
            "AUTOPILOT — OFF",
            "Fly green zone on PFD VSI",
        ],
        steps: [
            ProcedureStep(action: "AUTOPILOT", detail: "DISCONNECT"),
            ProcedureStep(action: "FOLLOW RA", detail: "Fly the green arc on VSI scale — immediately"),
            ProcedureStep(action: "AVOID red arc", detail: "Do NOT enter red zone on VSI"),
            ProcedureStep(action: "ATC instructions", detail: "IGNORE if conflicting with RA"),
            ProcedureStep(action: "When 'CLEAR OF CONFLICT'", detail: "Return to assigned altitude/heading"),
            ProcedureStep(action: "ATC", detail: "ADVISE 'TCAS RA' and report when clear"),
            ProcedureStep(action: "If RA reversal occurs", detail: "Follow new RA guidance promptly"),
        ],
        notes: [
            "RA takes absolute priority over ATC instructions",
            "Do not maneuver opposite to RA based on visual contact alone",
            "After RA compliance, advise ATC: 'TCAS RA, [climbing/descending]'",
            "File ASR (Air Safety Report) after any RA event",
        ]
    )

    static let windshearEscape = EmergencyProcedure(
        title: "Windshear Escape",
        subtitle: "Windshear / microburst escape maneuver",
        severity: .warning,
        icon: "wind.circle.fill",
        memoryItems: [
            "TOGA — SET",
            "ROTATE — 17.5° pitch",
            "Do NOT change configuration",
        ],
        steps: [
            ProcedureStep(action: "THRUST LEVERS", detail: "TOGA (immediately)"),
            ProcedureStep(action: "PITCH", detail: "Rotate to 17.5° nose up"),
            ProcedureStep(action: "FOLLOW SRS orders", detail: "SRS FD bars provide escape guidance"),
            ProcedureStep(action: "CONFIGURATION", detail: "Do NOT change flaps or gear"),
            ProcedureStep(action: "If stick shaker", detail: "Reduce pitch slightly but maintain TOGA thrust"),
            ProcedureStep(action: "SPEED BRAKES", detail: "Verify RETRACTED"),
            ProcedureStep(action: "When clear of windshear", detail: "Resume normal flight path"),
            ProcedureStep(action: "ATC", detail: "REPORT windshear, location, altitude"),
        ],
        notes: [
            "Predictive windshear: CAUTION below 1,500ft AGL, WARNING below 1,100ft AGL on approach",
            "On takeoff: if windshear warning before V1 — REJECT (unless already committed)",
            "On approach: GO AROUND if windshear warning or caution at low altitude",
            "17.5° pitch is the target — higher may stall, lower may not escape",
        ]
    )

    static let ditching = EmergencyProcedure(
        title: "Ditching",
        subtitle: "Controlled water landing",
        severity: .warning,
        icon: "water.waves",
        memoryItems: [
            "CABIN — PREPARE FOR DITCHING",
            "DITCHING P/B — ON",
            "LAND into wind or along swell",
        ],
        steps: [
            ProcedureStep(action: "MAYDAY", detail: "DECLARE — position, intentions, souls on board"),
            ProcedureStep(action: "SQUAWK 7700", detail: "Transponder emergency"),
            ProcedureStep(action: "DITCHING P/B", detail: "ON (closes all valves below waterline)"),
            ProcedureStep(action: "CABIN CREW", detail: "BRIEF — brace positions, life vest donning, raft deployment"),
            ProcedureStep(action: "PA TO PASSENGERS", detail: "'PREPARE FOR DITCHING' — don life vests, brace"),
            ProcedureStep(action: "GEAR", detail: "UP (do NOT extend gear for ditching)"),
            ProcedureStep(action: "FLAPS", detail: "FULL"),
            ProcedureStep(action: "APPROACH", detail: "Fly into wind or parallel to swells"),
            ProcedureStep(action: "SPEED", detail: "Minimum safe speed — VREF or slightly above"),
            ProcedureStep(action: "TOUCHDOWN", detail: "Wings level, slight nose up, minimum descent rate"),
            ProcedureStep(action: "AFTER TOUCHDOWN", detail: "EVACUATE via overwing exits and rafts"),
        ],
        notes: [
            "A320 has been successfully ditched (US Airways 1549, Hudson River, 2009)",
            "Ditching button closes outflow valve, avionics ventilation, pack flow valves, emergency RAM air, all below-waterline openings",
            "Do NOT inflate life vests inside aircraft",
            "Overwing exits preferred for water evacuation",
        ]
    )

    static let fuelLeak = EmergencyProcedure(
        title: "Fuel Leak",
        subtitle: "Fuel leak detected — ECAM FUEL LEAK",
        severity: .caution,
        icon: "fuelpump.exclamationmark.fill",
        steps: [
            ProcedureStep(action: "ECAM ACTIONS", detail: "FOLLOW fuel leak procedure"),
            ProcedureStep(action: "Affected engine", detail: "May need to be shut down per ECAM"),
            ProcedureStep(action: "FUEL CROSSFEED", detail: "As directed by ECAM"),
            ProcedureStep(action: "FUEL QUANTITY", detail: "MONITOR closely"),
            ProcedureStep(action: "PLAN", detail: "Divert to nearest suitable airport"),
            ProcedureStep(action: "ATC", detail: "DECLARE PAN PAN or MAYDAY based on severity"),
            ProcedureStep(action: "CALCULATE", detail: "Remaining fuel vs distance to diversion airport"),
            ProcedureStep(action: "LAND", detail: "As soon as practical"),
        ],
        notes: [
            "Fuel imbalance may indicate leak — crosscheck with fuel used",
            "Consider gravity feed capability if fuel pumps are lost",
            "Single engine fuel consumption approximately 2,500 kg/hr at cruise",
        ]
    )

    static let hydraulicFailure = EmergencyProcedure(
        title: "Hydraulic Failure",
        subtitle: "Green / Blue / Yellow system failure",
        severity: .caution,
        icon: "drop.triangle.fill",
        steps: [
            ProcedureStep(action: "ECAM ACTIONS", detail: "FOLLOW hydraulic failure procedure"),
            ProcedureStep(action: "IDENTIFY", detail: "Which system(s) failed: GREEN, BLUE, or YELLOW"),
            ProcedureStep(action: "GREEN failure effects", detail: "Nose wheel steering, brakes (normal), engine 1 reverser, flaps/slats (partial), gear (gravity extension)"),
            ProcedureStep(action: "BLUE failure effects", detail: "Slats, emergency generator, spoilers 3+4"),
            ProcedureStep(action: "YELLOW failure effects", detail: "Nose wheel steering (when towing), engine 2 reverser, flaps/slats (partial), some spoilers, cargo doors"),
            ProcedureStep(action: "DUAL failure", detail: "Significantly reduced flight control capability — ECAM will guide"),
            ProcedureStep(action: "GEAR EXTENSION", detail: "Use gravity extension if GREEN + YELLOW failed"),
            ProcedureStep(action: "APPROACH", detail: "Consider higher approach speed per ECAM, longer runway"),
            ProcedureStep(action: "AUTOBRAKE", detail: "May be inoperative — plan for manual braking"),
        ],
        notes: [
            "A320 has triple-redundant hydraulic system (Green, Blue, Yellow)",
            "Blue system: powered by electric pump (no engine-driven pump)",
            "PTU connects Green and Yellow for backup",
            "RAT powers Blue system if both engines fail",
        ]
    )

    static let electricalEmergency = EmergencyProcedure(
        title: "Electrical Emergency",
        subtitle: "AC BUS / DC BUS / total electrical failure",
        severity: .warning,
        icon: "bolt.trianglebadge.exclamationmark.fill",
        steps: [
            ProcedureStep(action: "ECAM ACTIONS", detail: "FOLLOW electrical failure procedure"),
            ProcedureStep(action: "IDENTIFY lost bus", detail: "AC BUS 1, AC BUS 2, DC BUS 1, DC BUS 2, AC ESS"),
            ProcedureStep(action: "APU", detail: "START (if not running)"),
            ProcedureStep(action: "APU GEN", detail: "ON — provides backup to AC BUS 1"),
            ProcedureStep(action: "If total AC loss", detail: "RAT extends automatically, powers AC ESS + blue hydraulics"),
            ProcedureStep(action: "BATTERIES", detail: "Provide minimum 30 minutes of emergency power"),
            ProcedureStep(action: "Shed non-essential loads", detail: "GALLEY OFF, commercial loads OFF"),
            ProcedureStep(action: "LAND", detail: "As soon as practical"),
        ],
        notes: [
            "AC ESS BUS can be manually switched to TR2 via overhead panel",
            "Total electrical failure: fly on standby instruments + backup battery",
            "Battery endurance: approximately 30 min (reduced with high electrical demand)",
            "In EMER ELEC CONFIG: only essential instruments available",
        ]
    )

    static let lossOfBraking = EmergencyProcedure(
        title: "Loss of Braking",
        subtitle: "Brake failure — normal and alternate",
        severity: .caution,
        icon: "brake.signal",
        steps: [
            ProcedureStep(action: "ECAM ACTIONS", detail: "FOLLOW braking failure procedure"),
            ProcedureStep(action: "AUTOBRAKE", detail: "May be INOP — select OFF"),
            ProcedureStep(action: "ALTERNATE BRAKING", detail: "Use if NORMAL braking lost — pedal braking without anti-skid"),
            ProcedureStep(action: "PARKING BRAKE", detail: "Available as emergency brake (3 applications typical)"),
            ProcedureStep(action: "REVERSE THRUST", detail: "Use MAX REVERSE to supplement braking"),
            ProcedureStep(action: "APPROACH", detail: "Select longest runway available"),
            ProcedureStep(action: "LANDING DISTANCE", detail: "Recalculate with degraded braking"),
            ProcedureStep(action: "After landing", detail: "Use reverse thrust to maximum, apply parking brake if needed"),
        ],
        notes: [
            "Normal braking: Green hydraulic + anti-skid",
            "Alternate braking: Yellow hydraulic accumulator (limited applications), NO anti-skid",
            "Without anti-skid: risk of tire burst — brake gently",
            "Parking brake: uses Yellow hydraulic accumulator",
        ]
    )

    // MARK: - Instrument Guides

    static let instrumentGuides: [InstrumentGuide] = [
        pfdGuide,
        ndGuide,
        ecamGuide,
        fcuGuide,
        mcduGuide,
        overheadGuide,
        pedestalGuide,
        glareshieldGuide,
        autopilotGuide,
        radioGuide
    ]

    static let pfdGuide = InstrumentGuide(
        name: "Primary Flight Display",
        abbreviation: "PFD",
        description: "Primary flight instrument showing attitude, airspeed, altitude, vertical speed, heading, and flight director/autopilot modes. Critical for instrument flying.",
        icon: "gauge.with.dots.needle.33percent",
        location: "Main instrument panel, directly in front of each pilot",
        sections: [
            InstrumentSection(title: "Airspeed Tape (Left Side)", items: [
                InstrumentDetail(label: "Speed Scale", description: "Current IAS/Mach, trends shown with yellow speed trend arrow", color: "green"),
                InstrumentDetail(label: "Speed Target (Magenta triangle)", description: "Managed speed target / selected speed", color: "magenta"),
                InstrumentDetail(label: "VLS (top of amber strip)", description: "Lowest Selectable Speed — minimum speed for current configuration"),
                InstrumentDetail(label: "ALPHA PROT (top of red/black strip)", description: "Angle of attack protection speed — auto pitch-down protection"),
                InstrumentDetail(label: "ALPHA MAX (red line)", description: "Maximum angle of attack — absolute minimum speed"),
                InstrumentDetail(label: "VFE (top of amber/red strip)", description: "Maximum Flap Extended speed — do not exceed with current flap setting"),
                InstrumentDetail(label: "Green Dot Speed", description: "Best lift/drag ratio speed in clean configuration (shown as green circle)"),
                InstrumentDetail(label: "S Speed", description: "Minimum slat retraction speed (shown as 'S' marker)"),
                InstrumentDetail(label: "F Speed", description: "Minimum flap retraction speed (shown as 'F' marker)"),
            ]),
            InstrumentSection(title: "Attitude Indicator (Center)", items: [
                InstrumentDetail(label: "Attitude Sphere", description: "Brown (ground) and blue (sky) with pitch lines every 2.5°/5°/10°"),
                InstrumentDetail(label: "Flight Director Bars", description: "Magenta FD cross bars showing commanded pitch and roll", color: "magenta"),
                InstrumentDetail(label: "Aircraft Symbol", description: "Yellow fixed symbol representing wings and nose"),
                InstrumentDetail(label: "Slip/Skid Indicator", description: "Yellow index below aircraft symbol — keep centered for coordinated flight"),
                InstrumentDetail(label: "Bank Angle Scale", description: "Marks at 10°, 20°, 30°, 45°, 67° bank"),
            ]),
            InstrumentSection(title: "Altitude Tape (Right Side)", items: [
                InstrumentDetail(label: "Altitude Scale", description: "Current barometric altitude in feet, 20ft resolution"),
                InstrumentDetail(label: "Altitude Target (Magenta)", description: "FCU selected altitude shown as magenta marker", color: "magenta"),
                InstrumentDetail(label: "Metric Altitude", description: "Shown in meters below digital readout when selected"),
                InstrumentDetail(label: "Radio Altitude (below 2,500ft)", description: "Actual height above ground — digital readout in green"),
            ]),
            InstrumentSection(title: "Vertical Speed (Far Right)", items: [
                InstrumentDetail(label: "VS Scale", description: "Analog scale showing vertical speed up to ±6000 fpm"),
                InstrumentDetail(label: "VS Digital Readout", description: "Appears when VS > ±200 fpm"),
            ]),
            InstrumentSection(title: "Heading / Track (Bottom)", items: [
                InstrumentDetail(label: "Heading Scale", description: "Rotating compass rose showing magnetic heading"),
                InstrumentDetail(label: "Selected Heading Bug", description: "Blue diamond — selected heading/track on FCU"),
                InstrumentDetail(label: "ILS Localizer Diamond", description: "Magenta diamond indicates lateral ILS deviation", color: "magenta"),
                InstrumentDetail(label: "Track Diamond", description: "Green diamond — actual track over ground", color: "green"),
            ]),
            InstrumentSection(title: "FMA (Flight Mode Annunciator — Top)", items: [
                InstrumentDetail(label: "Column 1 (Thrust)", description: "Active thrust mode: MAN TOGA, THR CLB, THR IDLE, A/THR (white = active, blue = armed)"),
                InstrumentDetail(label: "Column 2 (Vertical)", description: "Active vertical mode: SRS, CLB, DES, GS*, ALT, V/S, OP CLB/DES"),
                InstrumentDetail(label: "Column 3 (Lateral)", description: "Active lateral mode: RWY, HDG, NAV, LOC*, LOC, APP NAV"),
                InstrumentDetail(label: "Column 4", description: "AP, FD, A/THR engagement status"),
                InstrumentDetail(label: "Column 5", description: "Approach capability: CAT 1, CAT 2, CAT 3 SINGLE/DUAL, DH/MDA"),
            ]),
        ],
        color: .green
    )

    static let ndGuide = InstrumentGuide(
        name: "Navigation Display",
        abbreviation: "ND",
        description: "Multi-mode navigation display showing aircraft position relative to route, navaids, weather, terrain, and traffic. Modes include ROSE ILS, ROSE VOR, ROSE NAV, ARC, and PLAN.",
        icon: "map",
        location: "Main instrument panel, outboard of each PFD",
        sections: [
            InstrumentSection(title: "Display Modes", items: [
                InstrumentDetail(label: "ROSE ILS", description: "ILS approach mode — shows localizer/glideslope deviation with compass rose"),
                InstrumentDetail(label: "ROSE VOR", description: "VOR navigation — shows VOR radial, bearing, DME with compass rose"),
                InstrumentDetail(label: "ROSE NAV", description: "En route nav — flight plan, navaids, airports on compass rose"),
                InstrumentDetail(label: "ARC", description: "Forward-looking 90° arc with flight plan, weather, terrain"),
                InstrumentDetail(label: "PLAN", description: "North-up plan view of full flight plan — no heading reference"),
            ]),
            InstrumentSection(title: "Range Selection", items: [
                InstrumentDetail(label: "Range Selector", description: "10, 20, 40, 80, 160, 320nm — half range shown on ARC mode"),
                InstrumentDetail(label: "ZOOM on PLAN", description: "Adjusts the plan view scale"),
            ]),
            InstrumentSection(title: "Overlays", items: [
                InstrumentDetail(label: "WX (Weather Radar)", description: "Green: light precip, Yellow: moderate, Red: heavy, Magenta: turbulence"),
                InstrumentDetail(label: "TERR (Terrain)", description: "Green: safe clearance, Yellow: caution, Red: warning/impact"),
                InstrumentDetail(label: "TCAS Traffic", description: "Cyan: other traffic, Yellow: traffic advisory, Red: resolution advisory"),
                InstrumentDetail(label: "VOR/NDB Symbols", description: "Navaid symbols displayed when in range"),
                InstrumentDetail(label: "Airports", description: "Star symbol for airports within range"),
                InstrumentDetail(label: "Constraints", description: "Altitude/speed constraints shown on flight plan waypoints"),
            ]),
            InstrumentSection(title: "Information Fields", items: [
                InstrumentDetail(label: "Wind Arrow & Speed", description: "Upper left — current wind direction and speed"),
                InstrumentDetail(label: "GS / TAS", description: "Ground speed and true airspeed"),
                InstrumentDetail(label: "ETA / Distance", description: "To next waypoint and destination"),
                InstrumentDetail(label: "VOR/DME Info", description: "Tuned navaid identifier, frequency, bearing, distance"),
            ]),
        ],
        color: .blue
    )

    static let ecamGuide = InstrumentGuide(
        name: "Electronic Centralized Aircraft Monitor",
        abbreviation: "ECAM",
        description: "Dual-screen system displaying engine parameters (upper) and aircraft systems (lower). Provides real-time monitoring, abnormal procedure display, and checklists.",
        icon: "rectangle.split.2x1",
        location: "Center instrument panel between pilots",
        sections: [
            InstrumentSection(title: "Upper ECAM (Engine/Warning Display)", items: [
                InstrumentDetail(label: "N1 Gauges", description: "Engine fan speed (% of max) — primary thrust indication"),
                InstrumentDetail(label: "EGT Gauges", description: "Exhaust Gas Temperature — monitor for exceedances"),
                InstrumentDetail(label: "N2 Gauges", description: "Core engine speed (% of max)"),
                InstrumentDetail(label: "Fuel Flow", description: "Current fuel flow per engine (kg/hr or lb/hr)"),
                InstrumentDetail(label: "Slat/Flap Indicator", description: "Current and target position of slats and flaps"),
                InstrumentDetail(label: "Warning/Caution Messages", description: "Red (Level 3), Amber (Level 2), Green (memo) messages"),
            ]),
            InstrumentSection(title: "Lower ECAM (System Display)", items: [
                InstrumentDetail(label: "ENG Page", description: "Detailed engine parameters — oil pressure, temp, vibration"),
                InstrumentDetail(label: "BLEED Page", description: "Bleed air system — pack valves, temperatures, pressures"),
                InstrumentDetail(label: "PRESS Page", description: "Cabin pressurization — cabin altitude, differential pressure, outflow valve"),
                InstrumentDetail(label: "ELEC Page", description: "Electrical system — generators, buses, batteries"),
                InstrumentDetail(label: "HYD Page", description: "Hydraulic system — Green, Blue, Yellow pressure and quantity"),
                InstrumentDetail(label: "FUEL Page", description: "Fuel quantities per tank, total fuel, crossfeed, pumps"),
                InstrumentDetail(label: "APU Page", description: "APU parameters — N, EGT, bleed, generator"),
                InstrumentDetail(label: "COND Page", description: "Air conditioning — zone temps, trim air, pack flow"),
                InstrumentDetail(label: "DOOR Page", description: "Door status, slide arming, oxygen"),
                InstrumentDetail(label: "WHEEL Page", description: "Brakes, tire pressure, hydraulic brake pressure"),
                InstrumentDetail(label: "F/CTL Page", description: "Flight control surface positions and actuator status"),
                InstrumentDetail(label: "CRUISE Page", description: "Auto-displayed in cruise — summary of key systems"),
                InstrumentDetail(label: "STATUS Page", description: "Inoperative systems, limitations, approach procedures"),
            ]),
            InstrumentSection(title: "ECAM Warning Levels", items: [
                InstrumentDetail(label: "Level 3 — WARNING (Red)", description: "Master WARNING: continuous chime, red light, red ECAM message. Immediate action required.", color: "red"),
                InstrumentDetail(label: "Level 2 — CAUTION (Amber)", description: "Master CAUTION: single chime, amber light, amber ECAM message. Awareness + action at appropriate time.", color: "amber"),
                InstrumentDetail(label: "Level 1 — Advisory (Amber)", description: "ECAM caution message only — no master warning light or chime.", color: "amber"),
                InstrumentDetail(label: "Memo — (Green/White)", description: "Status information, flight phase reminders.", color: "green"),
            ]),
        ],
        color: .orange
    )

    static let fcuGuide = InstrumentGuide(
        name: "Flight Control Unit",
        abbreviation: "FCU",
        description: "Primary interface for autopilot/flight director commands. Controls speed, heading, altitude, and vertical speed selections. Pull = selected (manual), Push = managed (FMGC).",
        icon: "dial.medium",
        location: "Glareshield panel, center",
        sections: [
            InstrumentSection(title: "Speed Window (Left)", items: [
                InstrumentDetail(label: "SPD/MACH Knob", description: "Rotate: adjust speed target. Pull: selected speed. Push: managed speed (magenta on PFD)"),
                InstrumentDetail(label: "SPD/MACH Display", description: "Shows selected IAS or Mach number (---: managed)"),
                InstrumentDetail(label: "SPD/MACH Button", description: "Toggle between IAS and Mach display"),
            ]),
            InstrumentSection(title: "Heading Window (Left-Center)", items: [
                InstrumentDetail(label: "HDG/TRK Knob", description: "Rotate: adjust heading/track. Pull: selected heading. Push: managed lateral nav (NAV mode)"),
                InstrumentDetail(label: "HDG/TRK Display", description: "Shows selected heading/track (---: managed)"),
                InstrumentDetail(label: "HDG V/S — TRK FPA Toggle", description: "Toggle between heading/VS mode and track/FPA mode"),
            ]),
            InstrumentSection(title: "Altitude Window (Right-Center)", items: [
                InstrumentDetail(label: "ALT Knob", description: "Rotate: adjust target altitude (100ft or 1000ft increments)"),
                InstrumentDetail(label: "ALT Display", description: "Shows target altitude in feet"),
                InstrumentDetail(label: "100/1000 Selector", description: "Toggle altitude increment (100ft for fine, 1000ft for coarse)"),
                InstrumentDetail(label: "ALT Pull", description: "Open climb/descent (OP CLB/OP DES) — immediate level change"),
                InstrumentDetail(label: "ALT Push", description: "Managed altitude — FMGC manages climb/descent profile"),
            ]),
            InstrumentSection(title: "Vertical Speed / FPA Window (Right)", items: [
                InstrumentDetail(label: "V/S or FPA Knob", description: "Rotate: adjust VS (fpm) or FPA (degrees). Pull: engage V/S or FPA mode"),
                InstrumentDetail(label: "V/S or FPA Display", description: "Shows selected V/S or FPA value"),
            ]),
            InstrumentSection(title: "Autopilot Buttons", items: [
                InstrumentDetail(label: "AP1 / AP2", description: "Engage Autopilot 1 or 2 (both for CAT III)"),
                InstrumentDetail(label: "A/THR", description: "Engage/disengage autothrust"),
                InstrumentDetail(label: "LOC", description: "Arm/engage localizer capture mode"),
                InstrumentDetail(label: "APPR", description: "Arm approach mode (LOC + GS for ILS, or FINAL for RNAV)"),
                InstrumentDetail(label: "EXPED", description: "Expedite climb or descent (green dot/VMO)"),
            ]),
        ],
        color: .purple
    )

    static let mcduGuide = InstrumentGuide(
        name: "Multipurpose Control & Display Unit",
        abbreviation: "MCDU",
        description: "Primary interface for the FMGC (Flight Management and Guidance Computer). Used for flight planning, performance calculations, navigation, and radio tuning.",
        icon: "keyboard",
        location: "Center pedestal, one per pilot side",
        sections: [
            InstrumentSection(title: "Key Pages", items: [
                InstrumentDetail(label: "INIT A", description: "Flight number, FROM/TO airports, alternate, cost index, cruise FL"),
                InstrumentDetail(label: "INIT B (FUEL PRED)", description: "Fuel planning — block fuel, taxi fuel, ZFW/ZFWCG"),
                InstrumentDetail(label: "F-PLN", description: "Flight plan page — waypoints, airways, constraints, discontinuities"),
                InstrumentDetail(label: "PERF", description: "Performance pages for each flight phase (T.O., CLB, CRZ, DES, APPR, GA)"),
                InstrumentDetail(label: "RAD NAV", description: "Manual navaid tuning — VOR, ILS, ADF frequencies"),
                InstrumentDetail(label: "PROG", description: "Progress page — position, bearing/distance to waypoints, optimal/max FL"),
                InstrumentDetail(label: "DIR TO", description: "Direct-to function for flight plan shortcuts"),
                InstrumentDetail(label: "SEC F-PLN", description: "Secondary flight plan for what-if planning"),
                InstrumentDetail(label: "MCDU MENU", description: "Access to ATSU, AIDS, CFDS diagnostic functions"),
                InstrumentDetail(label: "DATA", description: "Waypoint, navaid, runway, and route database access"),
            ]),
            InstrumentSection(title: "PERF Pages Detail", items: [
                InstrumentDetail(label: "PERF T.O.", description: "V1, VR, V2, flex temp, thrust reduction/acceleration altitudes, flaps/THS"),
                InstrumentDetail(label: "PERF CLB", description: "Cost index, speed schedule, energy management"),
                InstrumentDetail(label: "PERF CRZ", description: "Cost index, optimum altitude, step climb planning"),
                InstrumentDetail(label: "PERF DES", description: "Descent profile, managed speed/path"),
                InstrumentDetail(label: "PERF APPR", description: "QNH, landing config, VAPP, minimums (DH/MDA), wind"),
                InstrumentDetail(label: "PERF GA", description: "Go-around parameters, missed approach procedure"),
            ]),
            InstrumentSection(title: "Color Coding", items: [
                InstrumentDetail(label: "Green text", description: "Active / navigable data", color: "green"),
                InstrumentDetail(label: "White text", description: "Entered data / confirmed entries", color: "white"),
                InstrumentDetail(label: "Blue text", description: "Modifiable fields", color: "blue"),
                InstrumentDetail(label: "Yellow text", description: "Constraints / limitations", color: "yellow"),
                InstrumentDetail(label: "Magenta text", description: "Mandatory entry required", color: "magenta"),
                InstrumentDetail(label: "Amber text", description: "Caution / error message", color: "amber"),
            ]),
        ],
        color: .cyan
    )

    static let overheadGuide = InstrumentGuide(
        name: "Overhead Panel",
        abbreviation: "OHP",
        description: "Contains all aircraft system controls organized by system. Uses 'dark cockpit' philosophy — all lights OFF in normal operation, illuminated lights indicate abnormal state.",
        icon: "rectangle.grid.3x2",
        location: "Overhead panel above windshield",
        sections: [
            InstrumentSection(title: "Panel Sections (Front to Rear)", items: [
                InstrumentDetail(label: "ADIRS Panel", description: "Air Data / Inertial Reference System — 3 units, OFF/NAV/ATT modes"),
                InstrumentDetail(label: "Flight Controls", description: "Flight computer switches, SEC/FAC computers"),
                InstrumentDetail(label: "ELEC Panel", description: "Generator switches, bus ties, battery, external power, APU gen"),
                InstrumentDetail(label: "FUEL Panel", description: "Fuel pump switches (6 pumps), crossfeed, fuel mode selector"),
                InstrumentDetail(label: "HYD Panel", description: "Engine-driven pumps, electric pumps, PTU, RAT"),
                InstrumentDetail(label: "AIR COND Panel", description: "Pack 1 & 2, hot air, zone temps, RAM air, ditching"),
                InstrumentDetail(label: "PRESS Panel", description: "Pressurization mode (AUTO/MAN), landing elevation, cabin VS"),
                InstrumentDetail(label: "ANTI ICE Panel", description: "Wing anti-ice, engine 1 & 2 anti-ice, probe heat"),
                InstrumentDetail(label: "CABIN PRESS Panel", description: "Landing elevation, auto/manual mode"),
                InstrumentDetail(label: "FIRE Panel", description: "Engine fire detection/extinguishing, APU fire"),
                InstrumentDetail(label: "EMER ELEC Panel", description: "Emergency generator test, GEN 1 LINE switch"),
                InstrumentDetail(label: "CALLS Panel", description: "Cockpit/cabin call buttons"),
                InstrumentDetail(label: "SIGNS Panel", description: "Seat belt, no smoking, emergency exit lights"),
                InstrumentDetail(label: "EXT LIGHTS Panel", description: "All exterior lighting controls"),
                InstrumentDetail(label: "INT LIGHTS Panel", description: "Dome, panel, flood lighting controls"),
                InstrumentDetail(label: "APU Panel", description: "APU master, APU start, APU bleed"),
            ]),
            InstrumentSection(title: "Dark Cockpit Philosophy", items: [
                InstrumentDetail(label: "No lights visible", description: "Aircraft is in normal configuration — everything nominal"),
                InstrumentDetail(label: "White light", description: "System is ON or position indication"),
                InstrumentDetail(label: "Green light", description: "System operating normally / valve open"),
                InstrumentDetail(label: "Blue light", description: "System selected but not yet active (transient)"),
                InstrumentDetail(label: "Amber FAULT light", description: "System fault / abnormal state — requires attention"),
                InstrumentDetail(label: "Red light", description: "Emergency / fire warning"),
            ]),
        ],
        color: .gray
    )

    static let pedestalGuide = InstrumentGuide(
        name: "Center Pedestal",
        abbreviation: "Pedestal",
        description: "Located between pilot seats, contains thrust levers, engine controls, flap lever, speed brake lever, trim wheel, MCDUs, RMP/ACP, and parking brake.",
        icon: "rectangle.portrait.split",
        location: "Between pilot and co-pilot seats",
        sections: [
            InstrumentSection(title: "Thrust Levers & Engine Controls", items: [
                InstrumentDetail(label: "Thrust Levers", description: "Dual thrust levers with TOGA, FLX/MCT, CL, IDLE detents"),
                InstrumentDetail(label: "TOGA Detent", description: "Takeoff/Go-Around thrust — max rated thrust"),
                InstrumentDetail(label: "FLX/MCT Detent", description: "Flex takeoff or Max Continuous Thrust"),
                InstrumentDetail(label: "CL (Climb) Detent", description: "Climb thrust — autothrust active range"),
                InstrumentDetail(label: "Engine Master Switches", description: "Engine 1 & 2 master start/stop switches"),
                InstrumentDetail(label: "Engine Mode Selector", description: "NORM / IGN START (continuous ignition for adverse conditions)"),
            ]),
            InstrumentSection(title: "Flight Controls", items: [
                InstrumentDetail(label: "Flap Lever", description: "Positions: 0, 1, 1+F, 2, 3, FULL"),
                InstrumentDetail(label: "Speed Brake Lever", description: "RET (retracted), ARM (armed for landing), manual deployment range"),
                InstrumentDetail(label: "Pitch Trim Wheels", description: "Manual pitch trim — rotary wheels on both sides of pedestal"),
                InstrumentDetail(label: "Rudder Trim", description: "Rotary knob for rudder trim adjustment"),
            ]),
            InstrumentSection(title: "Communications", items: [
                InstrumentDetail(label: "RMP (Radio Management Panel)", description: "VHF 1/2/3, HF 1/2, frequency selection and swap"),
                InstrumentDetail(label: "ACP (Audio Control Panel)", description: "Volume and selection for VHF, HF, interphone, PA"),
                InstrumentDetail(label: "Transponder Panel", description: "Squawk code, TCAS mode (STBY/TA/TA-RA), ADS-B"),
                InstrumentDetail(label: "ECAM Control Panel", description: "System page selection buttons for lower ECAM, CLR, RCL, STS"),
            ]),
            InstrumentSection(title: "Other Controls", items: [
                InstrumentDetail(label: "Parking Brake", description: "Yellow handle — pull for ON, push for OFF"),
                InstrumentDetail(label: "Gravity Gear Extension", description: "Handle for emergency gravity gear extension (below pedestal)"),
                InstrumentDetail(label: "Cockpit Door Control", description: "LOCK/NORM/OPEN selector"),
                InstrumentDetail(label: "Weather Radar Panel", description: "SYS 1/2 selection, gain, tilt, mode (WX/TURB/MAP)"),
            ]),
        ],
        color: .brown
    )

    static let glareshieldGuide = InstrumentGuide(
        name: "Glareshield",
        abbreviation: "Glareshield",
        description: "Contains the FCU (Flight Control Unit), EFIS control panels (one per pilot), master warning/caution lights, autoland lights, and clock.",
        icon: "rectangle.topthird.inset.filled",
        location: "Top of main instrument panel, below windshield",
        sections: [
            InstrumentSection(title: "EFIS Control Panel (one per pilot)", items: [
                InstrumentDetail(label: "Baro Setting", description: "QNH/QFE/STD selector with rotary knob, inHg/hPa toggle"),
                InstrumentDetail(label: "FD Button", description: "Flight Director ON/OFF for respective side"),
                InstrumentDetail(label: "LS Button", description: "Landing System ON/OFF — shows ILS deviation scales on PFD"),
                InstrumentDetail(label: "ND Mode Selector", description: "ILS / VOR / NAV / ARC / PLAN modes"),
                InstrumentDetail(label: "ND Range Selector", description: "10 / 20 / 40 / 80 / 160 / 320 nm"),
                InstrumentDetail(label: "CSTR Button", description: "Show/hide flight plan constraints on ND"),
                InstrumentDetail(label: "WPT Button", description: "Show/hide waypoints on ND"),
                InstrumentDetail(label: "VOR.D Button", description: "Show/hide VOR/DME stations on ND"),
                InstrumentDetail(label: "NDB Button", description: "Show/hide NDB stations on ND"),
                InstrumentDetail(label: "ARPT Button", description: "Show/hide airports on ND"),
            ]),
            InstrumentSection(title: "Warning/Caution Lights", items: [
                InstrumentDetail(label: "MASTER WARNING (Red)", description: "Red pushbutton — flashes with aural warning. Press to acknowledge.", color: "red"),
                InstrumentDetail(label: "MASTER CAUTION (Amber)", description: "Amber pushbutton — illuminates with single chime. Press to acknowledge.", color: "amber"),
                InstrumentDetail(label: "AUTOLAND Warning", description: "Red AUTOLAND light — approach capability failure below 200ft"),
                InstrumentDetail(label: "SIDESTICK Priority", description: "Green CAPT/FO arrow — indicates which sidestick has priority"),
            ]),
        ],
        color: .yellow
    )

    static let autopilotGuide = InstrumentGuide(
        name: "Autopilot / Flight Director",
        abbreviation: "AP/FD",
        description: "Dual-channel autopilot with flight director and autothrust. Supports managed (FMGC) and selected (pilot) modes for lateral and vertical navigation.",
        icon: "point.topleft.down.to.point.bottomright.curvepath.fill",
        location: "Controlled from FCU on glareshield",
        sections: [
            InstrumentSection(title: "Autopilot Modes", items: [
                InstrumentDetail(label: "AP1 / AP2", description: "Independent autopilot channels — one for normal ops, both for CAT III"),
                InstrumentDetail(label: "Flight Director", description: "FD bars on PFD — provides guidance even when AP not engaged"),
                InstrumentDetail(label: "Autothrust", description: "Manages thrust from IDLE to CLB detent. Speed/Mach/Thrust modes."),
            ]),
            InstrumentSection(title: "Lateral Modes", items: [
                InstrumentDetail(label: "HDG / TRK", description: "Selected heading/track — fly FCU selected value"),
                InstrumentDetail(label: "NAV", description: "Managed lateral nav — follows FMGC flight plan"),
                InstrumentDetail(label: "LOC *", description: "Localizer capture — armed/capturing localizer beam"),
                InstrumentDetail(label: "LOC", description: "Localizer captured and tracking"),
                InstrumentDetail(label: "RWY", description: "Runway mode — takeoff lateral guidance"),
                InstrumentDetail(label: "GA TRK", description: "Go-around track mode — maintains current track"),
            ]),
            InstrumentSection(title: "Vertical Modes", items: [
                InstrumentDetail(label: "SRS", description: "Speed Reference System — maintains V2/V2+10 on takeoff, VAPP on go-around"),
                InstrumentDetail(label: "CLB / DES", description: "Managed climb/descent — follows FMGC profile"),
                InstrumentDetail(label: "OP CLB / OP DES", description: "Open climb/descent — climb/descend at selected speed to FCU altitude"),
                InstrumentDetail(label: "V/S — FPA", description: "Selected vertical speed or flight path angle"),
                InstrumentDetail(label: "ALT * / ALT", description: "Altitude capture / altitude hold"),
                InstrumentDetail(label: "GS *", description: "Glideslope capture — armed/capturing glideslope"),
                InstrumentDetail(label: "GS", description: "Glideslope captured and tracking"),
                InstrumentDetail(label: "FINAL", description: "RNAV approach final descent mode"),
                InstrumentDetail(label: "FLARE", description: "Autoland flare maneuver (below 40ft RA)"),
                InstrumentDetail(label: "ROLL OUT", description: "Automatic rollout guidance after touchdown"),
                InstrumentDetail(label: "EXPED", description: "Expedite — climb at green dot, descend at VMO/MMO"),
            ]),
            InstrumentSection(title: "Thrust Modes", items: [
                InstrumentDetail(label: "MAN TOGA", description: "Manual takeoff/go-around thrust"),
                InstrumentDetail(label: "MAN FLX", description: "Manual flex/derated takeoff thrust"),
                InstrumentDetail(label: "THR CLB", description: "Climb thrust — max continuous climb power"),
                InstrumentDetail(label: "THR IDLE", description: "Idle thrust — descent mode"),
                InstrumentDetail(label: "THR DES", description: "Descent thrust — idle or as required"),
                InstrumentDetail(label: "SPEED / MACH", description: "Autothrust controlling to speed/Mach target"),
            ]),
            InstrumentSection(title: "Protections (Normal Law)", items: [
                InstrumentDetail(label: "ALPHA PROT", description: "Pitch protection — AOA limited, auto pitch-down above ALPHA PROT"),
                InstrumentDetail(label: "ALPHA FLOOR", description: "Automatic TOGA thrust if AOA exceeds limit (below ALPHA MAX)"),
                InstrumentDetail(label: "Load Factor Protection", description: "Limited to +2.5g / -1.0g in clean, +2.0g / 0g in config"),
                InstrumentDetail(label: "Pitch Attitude Protection", description: "Nose up: 30° max, Nose down: -15° max"),
                InstrumentDetail(label: "Bank Angle Protection", description: "67° max bank, auto recovery above 33° with neutral stick"),
                InstrumentDetail(label: "High Speed Protection", description: "Auto pitch-up and nose-down authority limited at VMO/MMO"),
            ]),
        ],
        color: .teal
    )

    static let radioGuide = InstrumentGuide(
        name: "Radio / Communication Panel",
        abbreviation: "RMP/ACP",
        description: "Radio Management Panel for frequency control and Audio Control Panel for audio source selection and volume control.",
        icon: "antenna.radiowaves.left.and.right",
        location: "Center pedestal and glareshield",
        sections: [
            InstrumentSection(title: "Radio Management Panel (RMP)", items: [
                InstrumentDetail(label: "VHF 1", description: "Primary VHF comm — controlled by captain RMP"),
                InstrumentDetail(label: "VHF 2", description: "Secondary VHF comm — controlled by F/O RMP"),
                InstrumentDetail(label: "VHF 3", description: "Third VHF — data link or backup voice"),
                InstrumentDetail(label: "HF 1 / HF 2", description: "High Frequency — oceanic/remote area communication"),
                InstrumentDetail(label: "Active / Standby Windows", description: "Active frequency on top, standby below — press transfer button to swap"),
                InstrumentDetail(label: "Frequency Selection", description: "Use outer/inner knobs for MHz/kHz selection"),
                InstrumentDetail(label: "NAV Backup", description: "RMP can tune ILS/VOR in backup mode if FMGC fails"),
            ]),
            InstrumentSection(title: "Audio Control Panel (ACP)", items: [
                InstrumentDetail(label: "VHF 1/2/3 Volume & Select", description: "Knob for volume, push for transmit selection"),
                InstrumentDetail(label: "HF 1/2 Volume & Select", description: "HF radio volume and transmit"),
                InstrumentDetail(label: "INT (Interphone)", description: "Cockpit intercom, flight interphone, cabin interphone"),
                InstrumentDetail(label: "CAB (Cabin)", description: "Cabin PA and call"),
                InstrumentDetail(label: "PA", description: "Passenger address system — push to talk to cabin"),
                InstrumentDetail(label: "Voice Filter", description: "VOR, ILS, ADF ident audio ON/OFF"),
            ]),
            InstrumentSection(title: "Transponder", items: [
                InstrumentDetail(label: "Squawk Code Entry", description: "4-digit octal code (0-7) for ATC identification"),
                InstrumentDetail(label: "Mode Selector", description: "STBY / ON / TA / TA-RA (TCAS modes)"),
                InstrumentDetail(label: "IDENT Button", description: "Press to ident — highlights aircraft on ATC radar"),
                InstrumentDetail(label: "Emergency Codes", description: "7500: Hijack, 7600: Comm Failure, 7700: Emergency"),
                InstrumentDetail(label: "ADS-B", description: "Automatic Dependent Surveillance — Broadcast (always on)"),
            ]),
        ],
        color: .red
    )

    // MARK: - Approach Procedures

    static let approachProcedures: [ApproachProcedure] = [
        ilsApproach,
        vorApproach,
        vorDmeApproach,
        ndbApproach,
        rnavApproach,
        visualApproach,
        circlingApproach,
        locOnlyApproach
    ]

    static let ilsApproach = ApproachProcedure(
        name: "ILS Approach (CAT I / II / III)",
        type: .ils,
        icon: "scope",
        description: "Instrument Landing System — precision approach using localizer (lateral) and glideslope (vertical) guidance. Supports autoland for CAT II/III operations.",
        minimums: "CAT I: DH 200ft, RVR 550m | CAT II: DH 100ft, RVR 300m | CAT III: DH 50ft/0ft, RVR 200m/75m/0m",
        requiredEquipment: ["ILS receiver (dual for CAT II/III)", "Glideslope receiver", "Marker receiver (optional)", "Radio altimeter", "Autopilot (dual for CAT III)"],
        steps: [
            ProcedureStep(action: "ATIS", detail: "Obtain and verify ILS approach in use"),
            ProcedureStep(action: "MCDU RAD NAV", detail: "Verify ILS frequency auto-tuned (or manual tune)"),
            ProcedureStep(action: "LS Button", detail: "Push ON on EFIS — displays LOC/GS scales on PFD"),
            ProcedureStep(action: "PERF APPR Page", detail: "Enter QNH, TEMP, WIND, DH/MDA, VAPP"),
            ProcedureStep(action: "FCU", detail: "Select approach speed, set go-around altitude"),
            ProcedureStep(action: "APPR Button", detail: "Push on FCU — arms LOC* and GS* modes"),
            ProcedureStep(action: "Intercept Localizer", detail: "LOC* → LOC captured (blue → green on FMA)"),
            ProcedureStep(action: "Intercept Glideslope", detail: "GS* → GS captured — begin descent on glideslope"),
            ProcedureStep(action: "Gear DOWN", detail: "Select gear down, verify 3 greens"),
            ProcedureStep(action: "Flaps", detail: "Configure progressively — CONF 2, 3, FULL"),
            ProcedureStep(action: "At 1000ft AGL", detail: "Stable approach check — speed, config, on glideslope/localizer"),
            ProcedureStep(action: "At DH / MDA", detail: "DECIDE: Land (visual reference) or Go-Around"),
            ProcedureStep(action: "If CAT III Autoland", detail: "Monitor LAND mode on FMA, hands on thrust levers"),
            ProcedureStep(action: "Touchdown", detail: "Verify ROLLOUT mode, apply reverse and braking"),
        ],
        fmgcSetup: [
            "F-PLN: Verify ILS approach selected with correct runway",
            "RAD NAV: ILS freq/course auto-populated from database",
            "PERF APPR: QNH, wind, DH (CAT I: 200, CAT II: 100, CAT III: 50 or NO DH)",
            "LS button ON on both EFIS panels",
        ],
        notes: [
            "Managed approach (APPR on FCU) provides automatic LOC/GS capture",
            "CAT II requires: both AP channels, autoland warning system",
            "CAT III requires: dual AP, dual FD, triple IRS, autoland",
            "Go-around: TOGA, follow SRS, positive rate → gear up",
        ]
    )

    static let vorApproach = ApproachProcedure(
        name: "VOR Approach",
        type: .vor,
        icon: "antenna.radiowaves.left.and.right",
        description: "Non-precision approach using VOR radial for lateral guidance. Vertical guidance is step-down or CDFA (Continuous Descent Final Approach) technique. No glideslope.",
        minimums: "Typical MDA: 500-800ft AGL, visibility 1-2 SM",
        requiredEquipment: ["VOR receiver", "DME (if VOR/DME)", "Radio altimeter recommended"],
        steps: [
            ProcedureStep(action: "MCDU RAD NAV", detail: "Verify VOR frequency tuned and identified"),
            ProcedureStep(action: "ND MODE", detail: "Select ROSE VOR mode on EFIS"),
            ProcedureStep(action: "PERF APPR Page", detail: "Enter QNH, MDA, VAPP"),
            ProcedureStep(action: "Course", detail: "Set inbound course on MCDU or verify from database"),
            ProcedureStep(action: "FCU", detail: "Select approach heading, set MDA-referenced altitude"),
            ProcedureStep(action: "Intercept final approach course", detail: "Track VOR radial inbound"),
            ProcedureStep(action: "At FAF / stepdown fix", detail: "Begin descent to MDA (CDFA or step-down)"),
            ProcedureStep(action: "Gear DOWN", detail: "Select gear down, verify 3 greens"),
            ProcedureStep(action: "Flaps FULL", detail: "Configure for landing"),
            ProcedureStep(action: "At MDA", detail: "Level off if no visual. If visual — continue to land"),
            ProcedureStep(action: "At MAP (Missed Approach Point)", detail: "If no visual contact → execute missed approach"),
        ],
        fmgcSetup: [
            "F-PLN: Select VOR approach for runway",
            "RAD NAV: VOR freq should auto-tune from flight plan",
            "PERF APPR: Set MDA (not DH), QNH, wind",
            "Consider selected NAV mode for final if managed not capturing correctly",
        ],
        notes: [
            "Non-precision approach — no vertical guidance from ground equipment",
            "Use CDFA technique: constant descent angle (typically 3°) for stabilized approach",
            "MDA — do not descend below MDA unless runway environment in sight",
            "Timing from FAF may be required for MAP identification",
        ]
    )

    static let vorDmeApproach = ApproachProcedure(
        name: "VOR/DME Approach",
        type: .vorDme,
        icon: "antenna.radiowaves.left.and.right",
        description: "Non-precision approach using VOR radial for course and DME for distance. Step-down fixes defined by DME distances from the VOR.",
        minimums: "Typical MDA: 400-700ft AGL, visibility 1-2 SM",
        requiredEquipment: ["VOR receiver", "DME receiver", "Radio altimeter recommended"],
        steps: [
            ProcedureStep(action: "MCDU RAD NAV", detail: "Verify VOR/DME frequency tuned and identified"),
            ProcedureStep(action: "ND MODE", detail: "Select ROSE VOR, verify DME readout"),
            ProcedureStep(action: "Step-down fixes", detail: "Note DME distances for each altitude restriction"),
            ProcedureStep(action: "Track inbound course", detail: "Using VOR radial"),
            ProcedureStep(action: "At each DME fix", detail: "Descend to next step-down altitude"),
            ProcedureStep(action: "Configure", detail: "Gear down, flaps as required"),
            ProcedureStep(action: "At MDA", detail: "Level off or continue if visual"),
            ProcedureStep(action: "MAP", detail: "Identified by DME distance from VOR"),
        ],
        fmgcSetup: [
            "F-PLN: VOR/DME approach from database",
            "RAD NAV: VOR/DME auto-tuned",
            "Monitor DME distance on ND or PFD",
        ],
        notes: [
            "DME distances are slant range — actual ground distance is less at close range/high altitude",
            "Verify DME is paired with the correct VOR (same facility)",
        ]
    )

    static let ndbApproach = ApproachProcedure(
        name: "NDB Approach",
        type: .ndb,
        icon: "dot.radiowaves.left.and.right",
        description: "Non-precision approach using NDB (Non-Directional Beacon) and ADF (Automatic Direction Finder). Oldest approach type, requires strong radio navigation skills.",
        minimums: "Typical MDA: 500-1000ft AGL, visibility 1.5-3 SM",
        requiredEquipment: ["ADF receiver", "Radio altimeter recommended"],
        steps: [
            ProcedureStep(action: "MCDU RAD NAV", detail: "Tune ADF frequency, verify ident"),
            ProcedureStep(action: "ND MODE", detail: "Select appropriate mode, verify ADF bearing pointer"),
            ProcedureStep(action: "Track to NDB", detail: "Using ADF relative bearing + heading = QDM"),
            ProcedureStep(action: "Procedure turn / reversal", detail: "If required by procedure"),
            ProcedureStep(action: "Inbound track", detail: "Maintain course using wind correction"),
            ProcedureStep(action: "At FAF (station passage or fix)", detail: "Begin descent"),
            ProcedureStep(action: "Configure", detail: "Gear down, flaps for landing"),
            ProcedureStep(action: "At MDA", detail: "Level off or land if visual"),
            ProcedureStep(action: "Station passage (needle flip)", detail: "If at MDA with no visual → missed approach"),
        ],
        notes: [
            "NDB approaches are being phased out in many countries",
            "ADF is susceptible to: thunderstorm interference, shoreline effect, mountain effect, night effect",
            "Requires mental math for wind correction — no CDI guidance",
        ]
    )

    static let rnavApproach = ApproachProcedure(
        name: "RNAV (GPS) Approach",
        type: .rnav,
        icon: "location.north.line",
        description: "Area navigation approach using GPS/GNSS. Supports LNAV, LNAV/VNAV, LPV minimums. A320 FMGC provides lateral and (if approved) vertical guidance.",
        minimums: "LNAV: MDA 300-600ft | LNAV/VNAV: DA 250-350ft | LPV: DA 200-250ft",
        requiredEquipment: ["GPS/GNSS receiver (FMGC)", "SBAS for LPV (if equipped)", "Radio altimeter"],
        steps: [
            ProcedureStep(action: "MCDU F-PLN", detail: "Select RNAV approach for runway"),
            ProcedureStep(action: "Verify approach", detail: "Check waypoints, altitude constraints match chart"),
            ProcedureStep(action: "PERF APPR", detail: "Enter QNH, MDA/DA, VAPP, wind"),
            ProcedureStep(action: "FCU APPR button", detail: "Push to arm FINAL APP mode"),
            ProcedureStep(action: "Monitor FINAL mode", detail: "FMA shows FINAL APP armed, then captured"),
            ProcedureStep(action: "At IF (Initial Fix)", detail: "Established on approach, descending per profile"),
            ProcedureStep(action: "At FAF", detail: "Final descent begins — verify on path"),
            ProcedureStep(action: "Gear DOWN, Flaps FULL", detail: "Configure for landing"),
            ProcedureStep(action: "At DA/MDA", detail: "DECIDE — visual or missed approach"),
            ProcedureStep(action: "Missed approach", detail: "TOGA, follow FMGC missed approach procedure"),
        ],
        fmgcSetup: [
            "F-PLN: Select RNAV approach from database, verify against chart",
            "Check GPS PRIMARY on ND or PROG page",
            "FINAL APP mode arms when: approach phase active, LOC/GS not armed",
            "Managed descent provides vertical guidance matching published path",
        ],
        notes: [
            "GPS PRIMARY required for RNAV approach — check on MCDU PROG page",
            "RAIM check: GPS integrity must be available at ETA",
            "A320 FMGC provides pseudo-glideslope for RNP approaches",
            "If GPS PRIMARY lost: missed approach unless other nav means approved",
            "Monitor cross-track deviation on ND (full-scale = 0.3nm final)",
        ]
    )

    static let visualApproach = ApproachProcedure(
        name: "Visual Approach",
        type: .visual,
        icon: "eye",
        description: "Approach conducted with visual reference to the terrain and runway. Requires minimum VMC conditions and pilot must have airport/runway in sight or preceding aircraft in sight.",
        minimums: "Visual — pilot judgment (typically 500ft AGL minimum recommended)",
        requiredEquipment: ["Visual reference to runway", "Minimum VMC weather conditions"],
        steps: [
            ProcedureStep(action: "CONFIRM", detail: "Airport/runway in sight"),
            ProcedureStep(action: "ATC", detail: "Report 'airport/field in sight'"),
            ProcedureStep(action: "ACCEPT visual approach clearance", detail: "Only if confident in visual contact"),
            ProcedureStep(action: "Fly visually", detail: "Aim for normal 3° glidepath"),
            ProcedureStep(action: "Use PAPI/VASI", detail: "2 red / 2 white = on path"),
            ProcedureStep(action: "FCU", detail: "May use selected V/S or managed if FMGC has visual approach programmed"),
            ProcedureStep(action: "Gear DOWN by 2000ft AGL", detail: "Latest — earlier is better"),
            ProcedureStep(action: "CONF FULL by 1000ft AGL", detail: "Stable approach criteria"),
            ProcedureStep(action: "At 500ft AGL", detail: "STABLE: speed, config, descent rate, on PAPI"),
            ProcedureStep(action: "If not stable at 500ft", detail: "GO AROUND"),
        ],
        notes: [
            "Visual approach ≠ 'see and avoid' — maintain awareness of terrain",
            "PAPI: 4 white = too high, 4 red = too low, 2+2 = on path",
            "Consider keeping ILS/RNAV armed as backup",
            "At night: treat visual approach with higher minimums and extra caution",
        ]
    )

    static let circlingApproach = ApproachProcedure(
        name: "Circling Approach",
        type: .circling,
        icon: "arrow.trianglehead.counterclockwise.rotate.90",
        description: "Maneuver after an instrument approach to align with a runway not served by the approach. Requires visual contact and adherence to circling minima and protected area.",
        minimums: "Cat C: MDA 500-700ft AGL, visibility 2400m | Cat D: MDA 600-800ft AGL, visibility 3600m",
        requiredEquipment: ["Instrument approach equipment for initial approach", "Visual reference for circling maneuver"],
        steps: [
            ProcedureStep(action: "FLY instrument approach", detail: "Complete to circling MDA"),
            ProcedureStep(action: "At circling MDA", detail: "Level off, acquire visual with runway environment"),
            ProcedureStep(action: "If visual acquired", detail: "Begin circling maneuver maintaining MDA minimum"),
            ProcedureStep(action: "CONFIGURATION", detail: "CONF 3 recommended for circling (better visibility, lower speed)"),
            ProcedureStep(action: "SPEED", detail: "Maintain VAPP for circling (higher than normal due to bank)"),
            ProcedureStep(action: "TURN to base/final", detail: "Keep runway in sight at all times"),
            ProcedureStep(action: "Align with landing runway", detail: "Descend from MDA only when aligned and in position to land"),
            ProcedureStep(action: "NORMAL LANDING", detail: "CONF FULL when established on short final"),
            ProcedureStep(action: "If visual lost", detail: "MISSED APPROACH — turn toward landing runway, then climb"),
        ],
        notes: [
            "A320 is Category C (VREF 121-140kt) or Cat D (VREF 141-165kt)",
            "Circling radius: Cat C = 4.2nm, Cat D = 5.28nm from runway threshold",
            "Keep circling maneuver inside protected airspace",
            "If visual lost during circling: immediate missed approach — turn toward runway, climb on published missed approach",
            "Night circling requires extreme caution — no terrain references",
        ]
    )

    static let locOnlyApproach = ApproachProcedure(
        name: "Localizer Only Approach",
        type: .loc,
        icon: "arrow.left.and.right",
        description: "Non-precision approach using ILS localizer for lateral guidance only (no glideslope). Used when glideslope is out of service. Step-down descent to MDA.",
        minimums: "Typical MDA: 400-600ft AGL, visibility 1-1.5 SM",
        requiredEquipment: ["ILS localizer receiver", "DME (if LOC/DME)", "Radio altimeter"],
        steps: [
            ProcedureStep(action: "MCDU RAD NAV", detail: "Verify LOC frequency tuned (same as ILS freq)"),
            ProcedureStep(action: "LS Button", detail: "ON — shows localizer on PFD (no glideslope display)"),
            ProcedureStep(action: "FCU LOC button", detail: "Push to arm LOC mode (not APPR — no GS)"),
            ProcedureStep(action: "PERF APPR", detail: "Enter QNH, MDA, VAPP"),
            ProcedureStep(action: "Capture LOC", detail: "LOC* → LOC on FMA"),
            ProcedureStep(action: "At FAF", detail: "Begin descent — use V/S or FPA for constant descent"),
            ProcedureStep(action: "CDFA Technique", detail: "Calculate required descent rate for ~3° path: GS × 5 = approx fpm"),
            ProcedureStep(action: "Configure", detail: "Gear DOWN, Flaps FULL"),
            ProcedureStep(action: "At MDA", detail: "Level off or continue if visual"),
            ProcedureStep(action: "Missed approach", detail: "If no visual at MAP — TOGA, climb, follow published missed approach"),
        ],
        fmgcSetup: [
            "F-PLN: Select LOC approach (not ILS)",
            "LOC button on FCU (not APPR) — arms localizer only",
            "No GS mode — use V/S for descent or managed if FMGC provides vertical",
        ],
        notes: [
            "Key difference from ILS: no glideslope — must manage descent manually",
            "CDFA recommended: maintain constant descent angle to minimize MDA level-off",
            "If LOC and ILS use same frequency, verify approach type selected correctly",
            "Higher minimums than ILS due to lack of vertical guidance",
        ]
    )

    // MARK: - FMGC Operations

    static let fmgcOperations: [FMGCOperation] = [
        flightPlanEntry,
        perfSetup,
        lateralNav,
        verticalNav,
        dirToFunction,
        holdFunction,
        secondaryFlightPlan,
        stepClimb,
        costIndex,
        windEntry
    ]

    static let flightPlanEntry = FMGCOperation(
        title: "Flight Plan Entry",
        subtitle: "Complete FMGC initialization for departure",
        icon: "map",
        mcduPage: "INIT A → F-PLN",
        steps: [
            FMGCStep(keyPress: "INIT", action: "Press INIT key to access INIT A page"),
            FMGCStep(keyPress: "1L", action: "Enter company route (if available) or leave blank"),
            FMGCStep(keyPress: "1R", action: "Enter FROM/TO airports (e.g., KJFK/KLAX)", display: "KJFK/KLAX"),
            FMGCStep(keyPress: "2R", action: "Enter alternate airport", display: "KONT"),
            FMGCStep(keyPress: "3R", action: "Enter flight number", display: "UAL123"),
            FMGCStep(keyPress: "5R", action: "Enter cost index (0-999)", display: "35"),
            FMGCStep(keyPress: "6R", action: "Enter cruise flight level", display: "FL370"),
            FMGCStep(keyPress: "F-PLN", action: "Press F-PLN key to access flight plan page"),
            FMGCStep(keyPress: "1L", action: "Select SID (Standard Instrument Departure)", display: "DEPARTURES→"),
            FMGCStep(keyPress: "Select SID", action: "Choose SID and transition from list"),
            FMGCStep(keyPress: "AIRWAYS", action: "Enter airways and waypoints for en route"),
            FMGCStep(keyPress: "STAR", action: "Select STAR and approach for destination"),
            FMGCStep(keyPress: "Check", action: "Verify all waypoints, discontinuities resolved, constraints correct"),
        ],
        tips: [
            "Resolve discontinuities: select waypoint AFTER disco, insert into waypoint BEFORE",
            "Company routes can pre-fill entire flight plan from database",
            "Cross-check waypoints with paper/EFB flight plan",
            "Enter lat/lon waypoints as: N4520.0W07340.5 format",
        ],
        color: .blue
    )

    static let perfSetup = FMGCOperation(
        title: "Performance Page Setup",
        subtitle: "Configure performance data for all phases",
        icon: "gauge.with.dots.needle.bottom.50percent",
        mcduPage: "PERF T.O. → APPR",
        steps: [
            FMGCStep(keyPress: "PERF", action: "Press PERF key — opens T.O. performance page"),
            FMGCStep(keyPress: "1L", action: "V1 — enter or confirm computed V1", display: "145"),
            FMGCStep(keyPress: "2L", action: "VR — enter or confirm rotation speed", display: "148"),
            FMGCStep(keyPress: "3L", action: "V2 — enter or confirm V2", display: "153"),
            FMGCStep(keyPress: "4L", action: "TRANS ALT — transition altitude", display: "18000"),
            FMGCStep(keyPress: "3R", action: "FLEX TEMP — enter flex/assumed temp for derate", display: "55"),
            FMGCStep(keyPress: "4R", action: "THR RED / ACC — thrust reduction & acceleration altitudes", display: "1500/1500"),
            FMGCStep(keyPress: "5R", action: "FLAPS/THS — takeoff flap and trim setting", display: "1/UP2.5"),
            FMGCStep(keyPress: "NEXT PHASE", action: "Press → key to advance to CLB page"),
            FMGCStep(keyPress: "PERF CLB", action: "Review CLB speed schedule — usually managed"),
            FMGCStep(keyPress: "PERF CRZ", action: "Verify cruise parameters, step alts if needed"),
            FMGCStep(keyPress: "PERF DES", action: "Review descent speed schedule"),
            FMGCStep(keyPress: "PERF APPR", action: "Enter: QNH, TEMP, WIND, MDA/DH, VAPP", display: "QNH/TEMP/WIND/DA-MDA"),
        ],
        tips: [
            "V-speeds must be entered manually or via ACARS uplink",
            "Flex temp reduces engine wear — use when performance allows",
            "THR RED/ACC: typically 1500ft AGL unless obstacle limited",
            "VAPP = VLS + 1/3 headwind component + gust increment (max additive: 15kt)",
        ],
        color: .green
    )

    static let lateralNav = FMGCOperation(
        title: "Lateral Navigation (LNAV)",
        subtitle: "Managing the horizontal flight path",
        icon: "arrow.triangle.turn.up.right.diamond",
        mcduPage: "F-PLN",
        steps: [
            FMGCStep(keyPress: "NAV Mode", action: "Push HDG knob on FCU to engage managed NAV mode"),
            FMGCStep(keyPress: "FMA shows NAV", action: "FMGC controls lateral path following flight plan"),
            FMGCStep(keyPress: "HDG Pull", action: "Pull HDG knob to enter SELECTED heading mode"),
            FMGCStep(keyPress: "HDG Rotate", action: "Rotate to select desired heading on FCU window"),
            FMGCStep(keyPress: "DIR TO", action: "Use DIR key for shortcuts to downstream waypoints"),
            FMGCStep(keyPress: "Monitor ND", action: "Watch cross-track deviation, time/distance to waypoints"),
        ],
        tips: [
            "NAV mode follows the programmed route — preferred for normal ops",
            "HDG mode: use for ATC vectors, weather deviations, traffic avoidance",
            "After vectors, push HDG knob to return to managed NAV",
            "Monitor ND ARC/ROSE NAV mode for best situational awareness",
        ],
        color: .cyan
    )

    static let verticalNav = FMGCOperation(
        title: "Vertical Navigation (VNAV)",
        subtitle: "Managing the vertical flight profile",
        icon: "arrow.up.right.and.arrow.down.left.rectangle",
        mcduPage: "PERF / PROG",
        steps: [
            FMGCStep(keyPress: "Managed CLB", action: "Push ALT knob → CLB mode — FMGC manages climb profile"),
            FMGCStep(keyPress: "OP CLB", action: "Pull ALT knob → Open Climb — climb at selected speed to FCU alt"),
            FMGCStep(keyPress: "Managed DES", action: "Push ALT knob → DES mode — follows computed descent path"),
            FMGCStep(keyPress: "OP DES", action: "Pull ALT knob → Open Descent — descend at selected speed"),
            FMGCStep(keyPress: "V/S", action: "Pull V/S knob → Selected vertical speed mode"),
            FMGCStep(keyPress: "EXPED", action: "Press EXPED button — climb at green dot / descend at VMO"),
            FMGCStep(keyPress: "ALT Constraint", action: "Flight plan constraints shown as magenta on ND"),
        ],
        tips: [
            "Managed descent (DES) gives best fuel efficiency — follows idle path",
            "OP DES: used when ATC gives 'descend at pilot discretion' off-profile",
            "DES mode: speed managed = ECON descent. Speed selected = at your speed, idle path.",
            "V/S mode has no speed protection — monitor speed manually!",
            "EXPED in descent = VMO/MMO — fastest descent, useful for late descents",
        ],
        color: .orange
    )

    static let dirToFunction = FMGCOperation(
        title: "DIR TO Function",
        subtitle: "Direct-to a waypoint in the flight plan",
        icon: "arrow.right",
        mcduPage: "DIR",
        steps: [
            FMGCStep(keyPress: "DIR", action: "Press DIR key on MCDU"),
            FMGCStep(keyPress: "1L-6L", action: "Select desired waypoint from flight plan list"),
            FMGCStep(keyPress: "OR type waypoint", action: "Enter waypoint identifier in scratchpad, then press DIR TO field"),
            FMGCStep(keyPress: "6R", action: "Press INSERT to confirm direct-to"),
            FMGCStep(keyPress: "Verify", action: "Check ND for new routing — waypoints between current position and selected point are removed"),
        ],
        tips: [
            "DIR TO removes all intermediate waypoints between you and the target",
            "ATC shortcut: 'proceed direct [waypoint]' — use DIR TO to comply",
            "Can combine with ABEAM point for offset tracking",
            "Verify the remaining route is correct after DIR TO",
        ],
        color: .purple
    )

    static let holdFunction = FMGCOperation(
        title: "Holding Patterns",
        subtitle: "Programming and flying holds in the FMGC",
        icon: "arrow.triangle.capsulepath",
        mcduPage: "F-PLN → HOLD",
        steps: [
            FMGCStep(keyPress: "F-PLN", action: "Navigate to waypoint where hold is desired"),
            FMGCStep(keyPress: "Select waypoint", action: "Press LSK next to hold waypoint"),
            FMGCStep(keyPress: "HOLD", action: "Select HOLD from lateral revision page"),
            FMGCStep(keyPress: "Define hold", action: "Enter: inbound course, turn direction, time/distance"),
            FMGCStep(keyPress: "INSERT", action: "Confirm hold entry into flight plan"),
            FMGCStep(keyPress: "FLY hold", action: "FMGC sequences entry, hold legs, and exit automatically"),
            FMGCStep(keyPress: "EXIT HOLD", action: "Press IMM EXIT on MCDU to exit hold at next opportunity"),
        ],
        tips: [
            "Published holds are in the database — select approach to load them",
            "FMGC computes hold entry (direct, parallel, or teardrop) automatically",
            "Fuel prediction updated while in hold",
            "Speed: Green dot (clean) or as published/assigned",
            "Max hold speed: 230kt below FL140, 240kt FL140-FL200, 265kt above FL200",
        ],
        color: .mint
    )

    static let secondaryFlightPlan = FMGCOperation(
        title: "Secondary Flight Plan",
        subtitle: "What-if planning without affecting active route",
        icon: "doc.on.doc",
        mcduPage: "SEC F-PLN",
        steps: [
            FMGCStep(keyPress: "SEC F-PLN", action: "Press SEC F-PLN key to create secondary plan"),
            FMGCStep(keyPress: "COPY ACTIVE", action: "Copy current active flight plan as starting point"),
            FMGCStep(keyPress: "Modify", action: "Change destination, route, approach — does NOT affect active plan"),
            FMGCStep(keyPress: "Review", action: "Check fuel, time, distance for alternate scenario"),
            FMGCStep(keyPress: "ACTIVATE", action: "If needed: press ACTIVATE to make secondary plan the active plan"),
            FMGCStep(keyPress: "DELETE", action: "Or DELETE to discard the secondary plan"),
        ],
        tips: [
            "Great for: alternate planning, re-routing, diversion what-if scenarios",
            "Secondary plan shown in dashed yellow on ND (if selected)",
            "Does not affect current navigation until ACTIVATED",
            "Only one secondary plan at a time",
        ],
        color: .indigo
    )

    static let stepClimb = FMGCOperation(
        title: "Step Climb / Descent",
        subtitle: "Programming altitude steps for optimum cruise",
        icon: "stairs",
        mcduPage: "PERF CRZ / F-PLN",
        steps: [
            FMGCStep(keyPress: "PROG", action: "Check OPT FL and MAX FL on progress page"),
            FMGCStep(keyPress: "F-PLN", action: "Navigate to waypoint for step climb"),
            FMGCStep(keyPress: "Select waypoint", action: "Press LSK next to step climb waypoint"),
            FMGCStep(keyPress: "Vertical revision", action: "Enter new cruise FL at that waypoint", display: "FL390"),
            FMGCStep(keyPress: "INSERT", action: "Confirm step climb entry"),
            FMGCStep(keyPress: "Verify", action: "Step shown as altitude change on ND and MCDU"),
        ],
        tips: [
            "Optimum FL increases as fuel burns off and aircraft gets lighter",
            "Step climb when OPT FL is 2000+ ft above current FL",
            "Request step climb from ATC in advance — 'request FL390 at [waypoint]'",
            "FMGC will compute T/C (top of climb) for the step",
        ],
        color: .teal
    )

    static let costIndex = FMGCOperation(
        title: "Cost Index",
        subtitle: "Understanding and setting cost index",
        icon: "dollarsign.circle",
        mcduPage: "INIT A",
        steps: [
            FMGCStep(keyPress: "INIT", action: "Access INIT A page"),
            FMGCStep(keyPress: "5R", action: "Enter cost index (0-999)", display: "CI 35"),
            FMGCStep(keyPress: "EFFECT", action: "Cost index affects: climb/cruise/descent speeds"),
        ],
        tips: [
            "CI 0 = minimum fuel (slow, long range cruise — Max Range speed)",
            "CI 999 = minimum time (fast, VMO/MMO — burn more fuel)",
            "Typical airline CI: 20-60 for medium/long haul, 60-100+ for short haul",
            "Cost index trades time cost vs fuel cost — set per airline policy",
            "Higher CI → higher cruise speed → more fuel burn → less flight time",
            "CI affects: ECON CLB speed, ECON CRZ speed, ECON DES speed",
        ],
        color: .yellow
    )

    static let windEntry = FMGCOperation(
        title: "Wind Entry",
        subtitle: "Entering wind data for FMGC predictions",
        icon: "wind",
        mcduPage: "WIND pages",
        steps: [
            FMGCStep(keyPress: "F-PLN", action: "Access flight plan page"),
            FMGCStep(keyPress: "Select waypoint", action: "Choose waypoint for wind entry"),
            FMGCStep(keyPress: "WIND", action: "Select WIND from revision page"),
            FMGCStep(keyPress: "Enter wind", action: "Format: direction/speed (e.g., 270/45)", display: "270/45"),
            FMGCStep(keyPress: "Altitude", action: "Enter wind for specific altitude if needed"),
            FMGCStep(keyPress: "INSERT", action: "Confirm wind entry"),
            FMGCStep(keyPress: "PERF APPR", action: "Also enter approach wind on PERF APPR page for VAPP calculation"),
        ],
        tips: [
            "Wind data improves: descent planning, fuel prediction, ETA accuracy",
            "ACARS can uplink wind data automatically (airline dependent)",
            "Approach wind on PERF APPR page: critical for VAPP calculation",
            "VAPP additive: 1/3 of headwind component, up to 15kt maximum",
            "Cruise wind: affects ground speed prediction and fuel planning",
        ],
        color: .gray
    )

    // MARK: - POH Reference

    static let pohSections: [POHSection] = [
        limitations,
        weightBalance,
        performanceTables,
        systemsDescription
    ]

    static let limitations = POHSection(
        title: "Aircraft Limitations",
        icon: "exclamationmark.triangle",
        subsections: [
            POHSubsection(title: "Speed Limitations", content: [
                POHEntry(parameter: "VMO (Max Operating Speed)", value: "350", unit: "KIAS", note: "Below FL316"),
                POHEntry(parameter: "MMO (Max Mach)", value: "0.82", unit: "Mach", note: "At/above crossover altitude"),
                POHEntry(parameter: "VLE (Max Gear Extended)", value: "280 / 0.67", unit: "KIAS / Mach"),
                POHEntry(parameter: "VLO Extend", value: "250 / 0.60", unit: "KIAS / Mach"),
                POHEntry(parameter: "VLO Retract", value: "220", unit: "KIAS"),
                POHEntry(parameter: "VFE Flap 1", value: "230", unit: "KIAS", note: "CONF 1"),
                POHEntry(parameter: "VFE Flap 1+F", value: "215", unit: "KIAS", note: "CONF 1+F"),
                POHEntry(parameter: "VFE Flap 2", value: "200", unit: "KIAS", note: "CONF 2"),
                POHEntry(parameter: "VFE Flap 3", value: "185", unit: "KIAS", note: "CONF 3"),
                POHEntry(parameter: "VFE Flap FULL", value: "177", unit: "KIAS", note: "CONF FULL"),
                POHEntry(parameter: "Max Tire Speed", value: "195", unit: "kts groundspeed"),
                POHEntry(parameter: "Max Wiper Speed", value: "230", unit: "KIAS"),
                POHEntry(parameter: "Max Window Open Speed", value: "200", unit: "KIAS"),
            ]),
            POHSubsection(title: "Weight Limitations", content: [
                POHEntry(parameter: "MTOW (A320-200 CEO)", value: "77,000", unit: "kg", note: "Typical, varies by variant"),
                POHEntry(parameter: "MTOW (A320neo)", value: "79,000", unit: "kg"),
                POHEntry(parameter: "MLW (A320-200)", value: "66,000", unit: "kg"),
                POHEntry(parameter: "MLW (A320neo)", value: "67,400", unit: "kg"),
                POHEntry(parameter: "MZFW (A320-200)", value: "62,500", unit: "kg"),
                POHEntry(parameter: "MZFW (A320neo)", value: "64,300", unit: "kg"),
                POHEntry(parameter: "Max Fuel Capacity", value: "24,210", unit: "liters", note: "~19,100 kg at SG 0.785"),
                POHEntry(parameter: "Max Payload", value: "~20,000", unit: "kg", note: "Depends on OEW and variant"),
            ]),
            POHSubsection(title: "Altitude Limitations", content: [
                POHEntry(parameter: "Max Operating Altitude", value: "39,100", unit: "ft", note: "Service ceiling"),
                POHEntry(parameter: "Max Certified Altitude", value: "39,800", unit: "ft"),
                POHEntry(parameter: "Max Altitude with One Pack", value: "25,000", unit: "ft"),
                POHEntry(parameter: "Max Airport Altitude for Takeoff", value: "9,200", unit: "ft"),
                POHEntry(parameter: "Max Cabin Differential Pressure", value: "8.06", unit: "psi"),
                POHEntry(parameter: "Max Cabin Altitude", value: "8,000", unit: "ft", note: "Normal operations"),
            ]),
            POHSubsection(title: "Engine Limitations (CFM56-5B / PW1100G)", content: [
                POHEntry(parameter: "Max N1 (Takeoff — 5 min)", value: "104.0", unit: "%", note: "CFM56-5B4"),
                POHEntry(parameter: "Max N1 (MCT)", value: "101.0", unit: "%"),
                POHEntry(parameter: "Max EGT (Takeoff)", value: "950", unit: "°C", note: "CFM56 series"),
                POHEntry(parameter: "Max EGT (MCT)", value: "915", unit: "°C"),
                POHEntry(parameter: "Max EGT Start", value: "725", unit: "°C"),
                POHEntry(parameter: "Max Reverse Time", value: "Unlimited", unit: "", note: "Idle reverse, 1 min max at max reverse"),
                POHEntry(parameter: "Oil Pressure Min", value: "13", unit: "psi"),
                POHEntry(parameter: "Oil Temperature Max", value: "155", unit: "°C"),
            ]),
            POHSubsection(title: "Environmental Limitations", content: [
                POHEntry(parameter: "Max Crosswind (Takeoff/Landing)", value: "38", unit: "kts", note: "Dry runway, demonstrated"),
                POHEntry(parameter: "Max Crosswind (Contaminated)", value: "15-25", unit: "kts", note: "Depends on contaminant"),
                POHEntry(parameter: "Max Tailwind (Takeoff)", value: "10", unit: "kts"),
                POHEntry(parameter: "Max Tailwind (Landing)", value: "10", unit: "kts"),
                POHEntry(parameter: "Temperature Range (Operations)", value: "-54 to ISA+35", unit: "°C"),
                POHEntry(parameter: "Max Demonstrated Altitude Wind", value: "N/A", unit: "", note: "Refer to performance tables"),
            ]),
        ],
        color: .red
    )

    static let weightBalance = POHSection(
        title: "Weight & Balance",
        icon: "scalemass",
        subsections: [
            POHSubsection(title: "Reference Data", content: [
                POHEntry(parameter: "OEW (Typical A320-200)", value: "42,600", unit: "kg", note: "Varies by configuration"),
                POHEntry(parameter: "OEW (Typical A320neo)", value: "44,300", unit: "kg"),
                POHEntry(parameter: "MAC (Mean Aerodynamic Chord)", value: "4.194", unit: "m"),
                POHEntry(parameter: "Datum", value: "Station 0", unit: "", note: "Forward of nose"),
                POHEntry(parameter: "CG Range (Takeoff)", value: "17% - 40%", unit: "MAC", note: "Forward to aft limit"),
                POHEntry(parameter: "CG Range (Landing)", value: "17% - 40%", unit: "MAC"),
                POHEntry(parameter: "Standard Passenger Weight", value: "84", unit: "kg", note: "Average with carry-on (EASA)"),
                POHEntry(parameter: "Cargo Hold Volume (Fwd)", value: "12.0", unit: "m³"),
                POHEntry(parameter: "Cargo Hold Volume (Aft)", value: "15.8", unit: "m³"),
                POHEntry(parameter: "Cargo Hold Volume (Bulk)", value: "3.6", unit: "m³"),
            ]),
            POHSubsection(title: "Fuel Tank Capacities", content: [
                POHEntry(parameter: "Wing Tank (each)", value: "6,267", unit: "liters"),
                POHEntry(parameter: "Center Tank", value: "6,476", unit: "liters"),
                POHEntry(parameter: "ACT (Additional Center Tank)", value: "5,200", unit: "liters", note: "Optional"),
                POHEntry(parameter: "Total Usable Fuel (standard)", value: "19,010", unit: "liters"),
                POHEntry(parameter: "Fuel Density (Jet A-1 standard)", value: "0.785", unit: "kg/liter"),
                POHEntry(parameter: "Total Usable Fuel (by weight)", value: "~18,730", unit: "kg"),
            ]),
        ],
        color: .blue
    )

    static let performanceTables = POHSection(
        title: "Performance Reference",
        icon: "chart.line.uptrend.xyaxis",
        subsections: [
            POHSubsection(title: "Takeoff Performance (Sea Level, ISA)", content: [
                POHEntry(parameter: "Takeoff Distance (MTOW, Flap 1)", value: "~2,190", unit: "m", note: "ISA, sea level, dry"),
                POHEntry(parameter: "Takeoff Distance (MTOW, Flap 2)", value: "~2,090", unit: "m"),
                POHEntry(parameter: "Takeoff Distance (Reduced, Flap 1+F)", value: "~1,800", unit: "m", note: "Typical reduced weight"),
                POHEntry(parameter: "V1 Range (MTOW)", value: "130-155", unit: "KIAS", note: "Varies with weight, altitude, temp"),
                POHEntry(parameter: "VR Range (MTOW)", value: "140-160", unit: "KIAS"),
                POHEntry(parameter: "V2 Range (MTOW)", value: "145-165", unit: "KIAS"),
                POHEntry(parameter: "Initial Climb Rate (MTOW)", value: "~2,500", unit: "fpm", note: "Both engines"),
                POHEntry(parameter: "One Engine Climb Rate", value: "~800", unit: "fpm", note: "Minimum at V2, MTOW"),
            ]),
            POHSubsection(title: "Cruise Performance", content: [
                POHEntry(parameter: "Typical Cruise Speed", value: "M 0.78", unit: "Mach", note: "LRC / ECON speed"),
                POHEntry(parameter: "Max Cruise Speed", value: "M 0.82", unit: "Mach", note: "MMO"),
                POHEntry(parameter: "Typical Cruise Altitude", value: "FL350-FL390", unit: "ft"),
                POHEntry(parameter: "Fuel Burn (Cruise, typical)", value: "2,300-2,500", unit: "kg/hr", note: "Both engines, mid-weight"),
                POHEntry(parameter: "Range (Max Pax, A320-200)", value: "~3,300", unit: "nm"),
                POHEntry(parameter: "Range (Max Pax, A320neo)", value: "~3,500", unit: "nm"),
                POHEntry(parameter: "Specific Range", value: "~0.045", unit: "nm/kg", note: "Nautical miles per kg fuel at optimum"),
                POHEntry(parameter: "Green Dot Speed (typical)", value: "220-250", unit: "KIAS", note: "Best L/D ratio speed, varies with weight"),
            ]),
            POHSubsection(title: "Approach & Landing Performance", content: [
                POHEntry(parameter: "VREF (MLW, CONF FULL)", value: "~131", unit: "KIAS"),
                POHEntry(parameter: "VAPP (typical)", value: "135-145", unit: "KIAS", note: "VREF + wind additive"),
                POHEntry(parameter: "Landing Distance (MLW, dry)", value: "~1,500", unit: "m", note: "Factored, sea level"),
                POHEntry(parameter: "Landing Distance (MLW, wet)", value: "~1,800", unit: "m", note: "Factored, sea level"),
                POHEntry(parameter: "Approach Angle", value: "3.0", unit: "degrees", note: "Standard ILS glideslope"),
                POHEntry(parameter: "Approach Rate of Descent", value: "~700", unit: "fpm", note: "On 3° at ~140kt GS"),
                POHEntry(parameter: "Go-Around Thrust", value: "TOGA", unit: "", note: "Or as required for obstacle clearance"),
            ]),
            POHSubsection(title: "Single Engine Performance", content: [
                POHEntry(parameter: "OEI Ceiling (MTOW)", value: "~20,000", unit: "ft", note: "Approximate, ISA"),
                POHEntry(parameter: "OEI Best Speed", value: "Green Dot", unit: "", note: "Best L/D ratio for single engine"),
                POHEntry(parameter: "OEI Drift-Down Rate", value: "~500", unit: "fpm", note: "From typical cruise altitude"),
                POHEntry(parameter: "VAPP (Single Engine)", value: "VAPP + 5", unit: "KIAS", note: "Add 5kt to normal VAPP"),
                POHEntry(parameter: "Approach Configuration", value: "CONF 3 recommended", unit: "", note: "Better go-around performance than FULL"),
            ]),
        ],
        color: .green
    )

    static let systemsDescription = POHSection(
        title: "Systems Description",
        icon: "gearshape.2",
        subsections: [
            POHSubsection(title: "Engines", content: [
                POHEntry(parameter: "A320ceo Engine Options", value: "CFM56-5A / CFM56-5B / V2500-A5", unit: ""),
                POHEntry(parameter: "A320neo Engine Options", value: "CFM LEAP-1A / PW1100G-JM", unit: ""),
                POHEntry(parameter: "Thrust Rating (CFM56-5B4)", value: "27,000", unit: "lbf"),
                POHEntry(parameter: "Thrust Rating (LEAP-1A26)", value: "27,120", unit: "lbf"),
                POHEntry(parameter: "Bypass Ratio (CFM56-5B)", value: "6.0:1", unit: ""),
                POHEntry(parameter: "Bypass Ratio (LEAP-1A)", value: "11.0:1", unit: ""),
                POHEntry(parameter: "FADEC", value: "Full Authority Digital Engine Control", unit: "", note: "Dual channel, per engine"),
            ]),
            POHSubsection(title: "Hydraulic System", content: [
                POHEntry(parameter: "Systems", value: "Green, Blue, Yellow", unit: "", note: "Triple redundant"),
                POHEntry(parameter: "Operating Pressure", value: "3,000", unit: "psi"),
                POHEntry(parameter: "Green System", value: "EDP 1", unit: "", note: "Engine 1 driven pump"),
                POHEntry(parameter: "Blue System", value: "Electric pump", unit: "", note: "Plus RAT for emergency"),
                POHEntry(parameter: "Yellow System", value: "EDP 2 + Electric pump", unit: "", note: "Engine 2 driven + electric"),
                POHEntry(parameter: "PTU", value: "Power Transfer Unit", unit: "", note: "Green ↔ Yellow cross-connection"),
                POHEntry(parameter: "RAT", value: "Ram Air Turbine", unit: "", note: "Auto-deploys, powers Blue system"),
                POHEntry(parameter: "Accumulator (Yellow)", value: "Parking brake + emergency braking", unit: ""),
            ]),
            POHSubsection(title: "Electrical System", content: [
                POHEntry(parameter: "Generators", value: "2 × IDG (Integrated Drive Generator)", unit: "", note: "One per engine, 90 kVA each"),
                POHEntry(parameter: "APU Generator", value: "1 × 90 kVA", unit: ""),
                POHEntry(parameter: "Emergency Generator", value: "5 kVA", unit: "", note: "Powered by Blue hydraulic (RAT)"),
                POHEntry(parameter: "Batteries", value: "2 × 25Ah", unit: "", note: "Hot battery bus, ~30 min endurance"),
                POHEntry(parameter: "AC Buses", value: "AC BUS 1, AC BUS 2, AC ESS", unit: "115V AC, 400Hz"),
                POHEntry(parameter: "DC Buses", value: "DC BUS 1, DC BUS 2, DC ESS, DC SHED", unit: "28V DC"),
                POHEntry(parameter: "External Power", value: "115V AC, 3-phase, 400Hz", unit: "", note: "Ground power connection"),
            ]),
            POHSubsection(title: "Flight Control System", content: [
                POHEntry(parameter: "Control Law", value: "Normal → Alternate → Direct → Mechanical", unit: ""),
                POHEntry(parameter: "Normal Law", value: "Full envelope protection", unit: "", note: "Load factor, pitch, bank, speed protections"),
                POHEntry(parameter: "Alternate Law", value: "Reduced protections", unit: "", note: "Load factor limited, no AOA protection"),
                POHEntry(parameter: "Direct Law", value: "No protections", unit: "", note: "Pilot inputs directly move surfaces"),
                POHEntry(parameter: "Mechanical Backup", value: "Pitch trim + rudder only", unit: ""),
                POHEntry(parameter: "Computers", value: "2 ELAC + 3 SEC + 2 FAC", unit: ""),
                POHEntry(parameter: "ELAC", value: "Elevator/Aileron Computer", unit: "", note: "Normal law, autopilot commands"),
                POHEntry(parameter: "SEC", value: "Spoiler/Elevator Computer", unit: "", note: "Backup for ELAC + spoiler control"),
                POHEntry(parameter: "FAC", value: "Flight Augmentation Computer", unit: "", note: "Yaw damper, rudder trim, windshear detection"),
            ]),
            POHSubsection(title: "Pressurization & Air Conditioning", content: [
                POHEntry(parameter: "Bleed Air Sources", value: "Engine 1, Engine 2, APU, External", unit: ""),
                POHEntry(parameter: "Packs", value: "2 × Air Cycle Machines", unit: "", note: "Pack 1 and Pack 2"),
                POHEntry(parameter: "Cabin Altitude (Cruise FL350)", value: "~6,900", unit: "ft"),
                POHEntry(parameter: "Max Differential Pressure", value: "8.06", unit: "psi"),
                POHEntry(parameter: "Outflow Valve", value: "Auto-controlled by pressurization controller", unit: ""),
                POHEntry(parameter: "Safety Valves", value: "2 positive relief + 1 negative relief", unit: ""),
                POHEntry(parameter: "Temperature Zones", value: "Cockpit, Forward Cabin, Aft Cabin", unit: ""),
                POHEntry(parameter: "RAM Air", value: "Emergency ventilation if both packs fail", unit: ""),
            ]),
            POHSubsection(title: "Fuel System", content: [
                POHEntry(parameter: "Tanks", value: "Left Wing, Right Wing, Center", unit: ""),
                POHEntry(parameter: "Fuel Pumps", value: "6 main (2 per tank) + 2 transfer", unit: ""),
                POHEntry(parameter: "Feed Sequence", value: "Center tank first, then wing tanks", unit: ""),
                POHEntry(parameter: "Crossfeed Valve", value: "1 × crossfeed between left and right", unit: ""),
                POHEntry(parameter: "Fuel Used Indication", value: "ECAM FUEL page", unit: ""),
                POHEntry(parameter: "Gravity Feed", value: "Available if all pumps fail (up to FL200 approx)", unit: ""),
                POHEntry(parameter: "APU Feed", value: "From left wing tank", unit: ""),
            ]),
        ],
        color: .indigo
    )

    // MARK: - Cockpit Targets for 3D Explorer

    static let cockpitTargets: [CockpitTarget] = [
        // Glareshield
        CockpitTarget(name: "FCU (Flight Control Unit)", description: "Speed, heading, altitude, VS selection and AP/FD controls", position: SIMD3(-200, 1100, 50), category: .glareshield),
        CockpitTarget(name: "Captain EFIS Control", description: "Baro setting, ND mode/range, FD/LS buttons", position: SIMD3(-400, 1100, 50), category: .glareshield),
        CockpitTarget(name: "F/O EFIS Control", description: "Baro setting, ND mode/range, FD/LS buttons", position: SIMD3(0, 1100, 50), category: .glareshield),
        CockpitTarget(name: "Master WARNING", description: "Red pushbutton — press to acknowledge level 3 warning", position: SIMD3(-350, 1100, 30), category: .glareshield),
        CockpitTarget(name: "Master CAUTION", description: "Amber pushbutton — press to acknowledge level 2 caution", position: SIMD3(-300, 1100, 30), category: .glareshield),

        // Main Instrument Panel
        CockpitTarget(name: "Captain PFD", description: "Primary Flight Display — attitude, airspeed, altitude, VS, heading, FMA", position: SIMD3(-500, 900, 50), category: .mainInstrumentPanel),
        CockpitTarget(name: "Captain ND", description: "Navigation Display — route, weather, terrain, traffic", position: SIMD3(-350, 900, 50), category: .mainInstrumentPanel),
        CockpitTarget(name: "Upper ECAM", description: "Engine parameters, warning/caution messages, memos", position: SIMD3(-200, 900, 50), category: .mainInstrumentPanel),
        CockpitTarget(name: "Lower ECAM", description: "System synoptic pages — selected or auto-displayed", position: SIMD3(-200, 750, 50), category: .mainInstrumentPanel),
        CockpitTarget(name: "F/O PFD", description: "First Officer's Primary Flight Display", position: SIMD3(0, 900, 50), category: .mainInstrumentPanel),
        CockpitTarget(name: "F/O ND", description: "First Officer's Navigation Display", position: SIMD3(150, 900, 50), category: .mainInstrumentPanel),
        CockpitTarget(name: "Standby Instruments", description: "Standby ASI, altimeter, attitude indicator — independent power and pitot", position: SIMD3(-100, 850, 50), category: .mainInstrumentPanel),
        CockpitTarget(name: "Clock / Chronometer", description: "Digital clock with elapsed time, UTC, and timer functions", position: SIMD3(-150, 800, 50), category: .mainInstrumentPanel),

        // Overhead Panel
        CockpitTarget(name: "ADIRS Panel", description: "3 ADIRS selectors — OFF/NAV/ATT. Align time ~7 min for full NAV", position: SIMD3(-200, 1200, 200), category: .overheadPanel),
        CockpitTarget(name: "ELEC Panel", description: "Generator, battery, bus tie, external power switches", position: SIMD3(-100, 1200, 250), category: .overheadPanel),
        CockpitTarget(name: "FUEL Panel", description: "Fuel pump switches, crossfeed, mode selector", position: SIMD3(-200, 1200, 300), category: .overheadPanel),
        CockpitTarget(name: "HYD Panel", description: "Green/Blue/Yellow system pumps, PTU, RAT", position: SIMD3(-100, 1200, 350), category: .overheadPanel),
        CockpitTarget(name: "AIR COND Panel", description: "Pack 1/2, hot air, zone temps, RAM air", position: SIMD3(-200, 1200, 400), category: .overheadPanel),
        CockpitTarget(name: "ANTI ICE Panel", description: "Wing and engine anti-ice, probe heat auto", position: SIMD3(-100, 1200, 450), category: .overheadPanel),
        CockpitTarget(name: "EXT LIGHTS Panel", description: "All exterior lighting: strobe, beacon, wing, nav, landing, taxi, turnoff, logo", position: SIMD3(-600, 1053, 19), category: .overheadPanel),
        CockpitTarget(name: "FIRE Panel", description: "Engine and APU fire detection, test, and extinguishing", position: SIMD3(-200, 1200, 500), category: .overheadPanel),
        CockpitTarget(name: "APU Panel", description: "APU master switch and start button", position: SIMD3(0, 1200, 200), category: .overheadPanel),

        // Center Pedestal
        CockpitTarget(name: "Thrust Levers", description: "Dual thrust levers — detents: TOGA, FLX/MCT, CL, IDLE, REV", position: SIMD3(-200, 600, 0), category: .pedestal),
        CockpitTarget(name: "Engine Masters", description: "Engine 1 and 2 master start/stop switches", position: SIMD3(-200, 650, 0), category: .pedestal),
        CockpitTarget(name: "Pilot-Side MCDU", description: "FMGC interface — flight plan, performance, navigation", position: SIMD3(-577, 551, 70), category: .pedestal),
        CockpitTarget(name: "F/O-Side MCDU", description: "Second FMGC interface — independent or synced with captain side", position: SIMD3(100, 551, 70), category: .pedestal),
        CockpitTarget(name: "Flap Lever", description: "Positions: 0, 1, 1+F, 2, 3, FULL — controls slats and flaps", position: SIMD3(-100, 500, 0), category: .pedestal),
        CockpitTarget(name: "Speed Brake Lever", description: "RET, ARM, manual deployment range for in-flight spoilers", position: SIMD3(-300, 500, 0), category: .pedestal),
        CockpitTarget(name: "Parking Brake", description: "Yellow handle — pull ON for parking brake", position: SIMD3(-200, 400, 0), category: .pedestal),
        CockpitTarget(name: "RMP / ACP", description: "Radio Management Panel and Audio Control Panel", position: SIMD3(-350, 480, 30), category: .pedestal),
        CockpitTarget(name: "Transponder Panel", description: "Squawk code, TCAS mode, IDENT button", position: SIMD3(-200, 450, 0), category: .pedestal),
        CockpitTarget(name: "ECAM Control Panel", description: "System page selection for lower ECAM — CLR, RCL, STS buttons", position: SIMD3(-100, 450, 0), category: .pedestal),
        CockpitTarget(name: "Weather Radar Panel", description: "SYS select, gain, tilt, WX/TURB/MAP mode", position: SIMD3(0, 480, 30), category: .pedestal),

        // Side Panel
        CockpitTarget(name: "Captain Sidestick", description: "Fly-by-wire control stick — pitch and roll input, priority button on top", position: SIMD3(-600, 700, -50), category: .sidePanel),
        CockpitTarget(name: "F/O Sidestick", description: "First Officer fly-by-wire control stick", position: SIMD3(200, 700, -50), category: .sidePanel),
    ]
}
