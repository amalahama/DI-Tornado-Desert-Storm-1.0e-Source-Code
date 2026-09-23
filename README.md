# Digital Integration: Tornado & Operation Desert Storm (Revision 1.0e)

## Project Overview & Accomplishment

This repository contains the reconstructed, bit-exact assembly source code, data assets, build scripts, and MS-DOS toolchain for **Digital Integration's Tornado & Operation Desert Storm** (Revision 1.0e, CD-ROM release, 1994).

Starting from the disassembled and leaked European floppy diskette v1.0a source code, the entire codebase was reverse-engineered, restructured, and updated to match the final CD-ROM release 1.0e. Through meticulous opcode analysis, relocation table alignment, and data segment reconstruction, this project achieves a **100.000000% byte-for-byte binary match (0 byte differences)** against the official release binaries for **both** simulation engines:

- **`FLIGHT.EXE` (European Theater Engine)**:
  - **Size**: 610,000 bytes
  - **SHA-256**: `4a6c6dc43a140d7486737a222a4e15ebc35beb9930965e20ad4c9c804144a185`
  - **Match**: 100.000000% (0 / 610,000 bytes difference)
  - **Relocations**: Exactly 1,902 relocations in identical order
  - **MZ Header Checksum**: `0x030E`

- **`DESERT.EXE` (Operation Desert Storm Expansion Engine)**:
  - **Size**: 612,832 bytes
  - **SHA-256**: `da57fac79f83ffdcbbdea9c88623a15d9e258c291ce6b60dd314ebc3c364086f`
  - **Match**: 100.000000% (0 / 612,832 bytes difference)
  - **Relocations**: Exactly 1,902 relocations in identical order
  - **MZ Header Checksum**: `0xFDC9`

### Key Engineering Milestones
1. **Creative Voice Driver Subsystem**: Fully reconstructed the Creative Voice Driver (`CT-VOICE.DRV`) API integration (`VOICE.ASM`, `VOICELIB.ASM`, `VOICEDAT.ASM`), segment isolation, and dynamic call vectors.
2. **Dual-Target Build Architecture**: Implemented dual-target build workflows (`BUILDALL.BAT`, `BUILD_FL.BAT`, `BUILD_DS.BAT`, `PAL_DS.BAT`, `L_DS.BAT`) with Microsoft Macro Assembler 6.11 (`/DDESERT`).
3. **Persian Gulf Theater Assets**: Fully restored the Kuwait/Iraq theater data structures, 8 real-world airfields (`DS_AIRF.ASM`), terrain elevation meshes (`DS_MAP.ASM`), palette gradients (`DS_PAL.ASM`), and Gulf War units (A-10, Apache, Su-27, Scud MAZ-543, Strela-10).
4. **Relocation & Checksum Fidelity**: Reconstructed exact relocation placement (such as relocation #1870 at `CODE:0xF5A`) and developed the 16-bit MS-DOS tool `CHKSUM.EXE` to calculate and apply the authentic 1's complement MZ header checksum.

---

```
==============================================================================
   DIGITAL INTEGRATION - TORNADO & OPERATION DESERT STORM (REVISION 1.0e)
         SOURCE CODE RECONSTRUCTION, DUAL-TARGET BUILD & RE DOCUMENTATION
==============================================================================

Table of Contents
-----------------
1. Project Overview & 100% Binary Exact Recreation
2. Build Environment & Automated Toolchain Setup
3. How to Build & Verify (BUILDALL.BAT, BUILD_FL.BAT, BUILD_DS.BAT)
4. Comprehensive Code Differences: Revision 1.0a (Floppy) vs Revision 1.0e (CD)
   4.1. Creative Voice Driver API Architecture & SoundBlaster Overhaul
   4.2. Rudder Pedals (/RP) & Fast Notebook Gameport Support
   4.3. Thrustmaster FCS & CH Products Flightstick Pro POV Hat Switch
   4.4. Tseng Labs ET4000/W32 Dual Vertical Retrace Workaround (/V2)
   4.5. Flight Model & Mission Termination Velocity Criteria (30 kts)
   4.6. Avionics, Air Intercept Radar Range Automation & Dogfight Mode
   4.7. Cockpit Instrumentation: Digital Fuel Quantity Readout
   4.8. Radar Warning Receiver (RWR) Audible Missile Proximity Alerts
   4.9. Progressive Combat Damage Modeling & SAM Lethality Retuning
   4.10. Parachute-Retarded Ordnance & JP233 Submunition Ballistics
   4.11. Soviet Mobile Air Defense: Strela 10 (ZREK-BD) 3D Model Replacement
   4.12. External Drone Camera View: Real-Time Aircraft Designation & Callsign
   4.13. Assembler Toolchain & Instruction Encoding Portability
5. Architectural Differences: FLIGHT.EXE (Europe) vs DESERT.EXE (Desert Storm)
   5.1. Theater Terrain Grids, Data Segments & Link Topologies
   5.2. Visual Palettes, Atmospheric Lighting & Cockpit Overlays
   5.3. Surface Feature Encodings & Hydrological Differences
   5.4. Ground Defenses & Battlefield Infrastructure
   5.5. Desert Storm Order of Battle, Unit Types & Drone Allocations
   5.6. Memory Layout, Data Alignment & Cross-Segment Offsets
6. Binary Verification Matrix & Checksums


==============================================================================
1. PROJECT OVERVIEW & 100% BINARY EXACT RECREATION
==============================================================================
This repository contains the reconstructed, bit-exact source code and build
environment for both simulation engines of Digital Integration's Tornado CD-ROM
edition (Revision 1.0e, released in 1994):

  - FLIGHT.EXE  : European Theater Simulation Engine (610,000 bytes)
  - DESERT.EXE  : Operation Desert Storm Expansion Engine (612,832 bytes)

Both executables compile with a 100.000000% byte-for-byte exact match (zero
differential bytes across code, data, far-data, stack, and relocation tables)
against the official Digital Integration CD-ROM binaries found in TORNADO.CD\FLIGHT.


==============================================================================
2. BUILD ENVIRONMENT & AUTOMATED TOOLCHAIN SETUP
==============================================================================
To achieve bit-for-bit identity under real-mode MS-DOS / DOSBox, the build system
relies on the authentic toolchain used by DI engineers in 1993-1994:

1. Assembler:
   Microsoft Macro Assembler Version 6.11 (MASM 6.11 / ML.EXE).
   - Case sensitivity flag: /Cp (preserves identifier case).
   - Target processor: 80286/8086 instructions.
   - For Desert Storm builds, the preprocessor symbol must be passed as
     uppercase: /DDESERT (MASM 6.11 internal symbol tables treat /ddesert as
     lowercase, which does not satisfy IFDEF DESERT).

2. Linker:
   Microsoft Segmented-Executable Linker Version 5.31.009 (LINK.EXE).
   - Segment alignment: /FARCALLTRANSLATION, /SEGMENTS:256, /PACKDATA.
   - Link orders configured in TORNADO\MAIN.LNK and TORNADO\MAIN_DS.LNK.

3. Executable Header Checksum Tool (CHKSUM.EXE):
   A specialized 16-bit MS-DOS assembly utility (source in TOOLS\MISC\CHKSUM.ASM,
   executable in MASM611\BIN\CHKSUM.EXE and TOOLS\MISC\CHKSUM.EXE).
   Computes the standard MS-DOS MZ header one's complement 16-bit checksum
   (~sum of all 16-bit words) and patches offset 0x12..0x13 so that the sum of
   the entire file equals 0xFFFF. This reproduces the exact checksum written by
   DI's post-processing pipeline in 1994 (0x030E for FLIGHT, 0xFDC9 for DESERT).


==============================================================================
3. HOW TO BUILD & VERIFY (BUILDALL.BAT, BUILD_FL.BAT, BUILD_DS.BAT)
==============================================================================
All builds should be executed in MS-DOS or DOSBox from the project root directory
(e.g., C:\TORNADO or your mounted drive root):

- Automated Full Build (Both Engines):
    BUILDALL.BAT
  Sequentially compiles and links FLIGHT.EXE and DESERT.EXE, applies the header
  checksums, and places the binaries in TORNADO\FLIGHT\.

- European Theater Engine Only:
    BUILD_FL.BAT
  Assembles LIB8086, VISUAL (European), and TORNADO (European), links MAIN.LNK,
  and stamps FLIGHT.EXE.

- Desert Storm Expansion Engine Only:
    BUILD_DS.BAT
  Assembles LIB8086, VISUAL (/DDESERT), and TORNADO (/DDESERT), links
  MAIN_DS.LNK, and stamps DESERT.EXE.

Directory-level scripts:
  - VISUAL\PAL.BAT    : Assemble European visual modules
  - VISUAL\PAL_DS.BAT : Assemble Desert Storm visual modules (/DDESERT)
  - TORNADO\PAL.BAT   : Assemble European flight/avionics modules
  - TORNADO\PAL_DS.BAT: Assemble Desert Storm flight/avionics modules (/DDESERT)
  - TORNADO\L.BAT     : Link FLIGHT.EXE and run CHKSUM.EXE
  - TORNADO\L_DS.BAT  : Link DESERT.EXE and run CHKSUM.EXE


==============================================================================
4. COMPREHENSIVE CODE DIFFERENCES: REVISION 1.0a (FLOPPY) VS REVISION 1.0e (CD)
==============================================================================
A detailed comparison between the initial release (1.0a floppy diskette) and
the CD-ROM release (1.0e) reveals major structural refactorings, hardware
driver additions, bug fixes, and combat balance adjustments:

4.1. Creative Voice Driver API Architecture & SoundBlaster Overhaul
-------------------------------------------------------------------
- 1.0a Architecture:
  In 1.0a, SOUNDFX.ASM communicated directly with Sound Blaster DSP hardware
  registers via manual port I/O and allocated low DOS memory dynamically
  using INT 21h AH=48h (PSIZE_SBLASTER). This caused frequent DMA collisions,
  crashes on clone DSP cards, interrupt conflicts, and bugs where continuous
  sound loops (such as the Master Warning klaxon) could never be silenced.

- 1.0e Architecture:
  Digital Integration replaced the entire direct DSP layer with the official
  Creative Voice Driver specification (CT-VOICE.DRV), isolating voice driver
  calls into three modular components:
    * TORNADO\VOICE.ASM   : Driver interface, resident call handlers, and
                            initialization vectors.
    * TORNADO\VOICELIB.ASM: Segment isolation for VOICELIB and VOICEDRV.
    * TORNADO\VOICEDAT.ASM: Voice sample descriptor tables and driver stubs.
  The engine now cleanly hooks and unhooks the driver on entry and exit:
    InstallVoice -> EnableVoice -> SetVoiceVolume -> PlayVoiceSample1..7 ->
    StopVoice -> DisableVoice -> RestoreVoice.
  In SOUNDFX.ASM, KillAttnBlst was redirected to KillAttnAdLb, resolving the
  infamous locked Master Warning bug.

4.2. Rudder Pedals (/RP) & Fast Notebook Gameport Support
---------------------------------------------------------
- Command Line Switch:
  Added the /RP argument (parsed in TORNADO\CONTROL.ASM), setting RudderPedals=1.
- Flight Dynamics Integration:
  In TORNADO\MODEL.ASM, rudder pedal axis input (ReadRudder) directly drives
  aerodynamic yaw moments via RP_Val and the JoyVals transfer curve, providing
  independent 3-axis flight control when a secondary joystick port or dual-Y
  cable is detected.
- Notebook Gameport Compatibility:
  LIB8086\JOYSTICK.ASM was extensively overhauled. The analog polling loops
  were redesigned with adaptive thresholding to support fast laptop gameports
  and high-clock 486/Pentium motherboards without axis overflow. Joystick B
  calibration bounds (_JB_MinX, _JB_MinY, _JB_MidX, _JB_MidY, _JB_MaxX,
  _JB_MaxY) were introduced in DATAXCHG.ASM.

4.3. Thrustmaster FCS & CH Products Flightstick Pro POV Hat Switch
------------------------------------------------------------------
- POV Coolie Hat:
  Added full 4-position POV hat switch decoding to LIB8086\JOYSTICK.ASM:
  TM_CoolieCn, TM_CoolieLt, TM_CoolieDn, TM_CoolieRt, and TM_CoolieHat.
- View Switching:
  TORNADO\VIEWS.ASM maps hat directions directly to cockpit perspective:
    * UP    : Pilot forward cockpit view / HUD
    * DOWN  : Pilot down view / instrument console
    * LEFT  : Navigator / Radar / Map view
    * RIGHT : Laser / TV / Auxiliary displays
- CH Products Flightstick Pro 4-Button Mapping:
  Trigger = Weapon Fire, Left = Cycle A-A weapons, Middle = Maneuver flaps
  toggle (in/out), Right = Airbrakes toggle.

4.4. Tseng Labs ET4000/W32 Dual Vertical Retrace Workaround (/V2)
-----------------------------------------------------------------
- Problem:
  Users of Tseng Labs ET4000/W32 Super VGA cards experienced severe screen
  flicker and tearing during hardware page flipping due to interleaved VRAM
  clock phase anomalies.
- Solution:
  Added command-line switch /V2 (TORNADO\CONTROL.ASM), enabling V2Mode.
  In LIB8086\VGA_DRVR.ASM, the page flip routine performs a synchronized double
  vertical blank wait (VLoop3 waiting for VSYNC end, VLoop4 waiting for VSYNC
  start on VGA_CRT_STAT port 03DAh), entirely eliminating the flicker artifact.

4.5. Flight Model & Mission Termination Velocity Criteria (30 kts)
------------------------------------------------------------------
- In 1.0a, TORNADO\MODEL.ASM strictly required the aircraft to have zero true
  airspeed (Vtas == 0) to end a mission.
- In 1.0e, the threshold was relaxed to allow mission termination once landed
  and ground speed drops below 30 knots:
    cmp Vtas, 0198h  ; 0x0198 = 408 decimal fixed-point units (~30 kts)

4.6. Avionics, Air Intercept Radar Range Automation & Dogfight Mode
-------------------------------------------------------------------
- Automatic Air Radar Range Selection:
  In TORNADO\AVIONICS.ASM, SetAirRadarRange reads the currently armed air-to-air
  weapon (AirArmMode) and automatically sets the radar display range:
    * Sidewinder AIM-9L -> 10 NM range
    * Sky Shadow ECM / Guns -> 5 NM range
- Quick-Reaction Dogfight Mode:
  In TORNADO\WEAPONS.ASM, if the pilot presses the fire button with weapon
  master arm in SAFE / OFF (ARM_OFF), the avionics immediately switch to
  ARM_AIR mode, arm Sidewinders, and power on the air intercept radar without
  manual keyboard mode toggling (WpnNoFire prevents accidental launch on the
  arming click).

4.7. Cockpit Instrumentation: Digital Fuel Quantity Readout
-----------------------------------------------------------
- Added a high-precision digital fuel weight indicator to the main pilot panel
  in TORNADO\PILOTPAN.ASM:
    Fuel$ (unsigned 5-digit decimal display of FuelWt at X=276, Y=195).
- TORNADO\VGAPANEL.ASM adds a fast localized redraw rectangle
  (REDRAW 276, 195, 24, 5) ensuring continuous flicker-free updates.
- Added digital font glyphs in TORNADO\VGA\SPRITES\HUDDIGIT.SS.

4.8. Radar Warning Receiver (RWR) Audible Missile Proximity Alerts
------------------------------------------------------------------
- In TORNADO\AVIONICS.ASM and DRONELIB.ASM, added MissileWarn and
  MissileWarnTimer. When an enemy missile enters active terminal tracking
  within immediate danger range, the RWR sounds a distinct audible warning tone
  to prompt defensive break-turns and flare/chaff deployment.

4.9. Progressive Combat Damage Modeling & SAM Lethality Retuning
----------------------------------------------------------------
- In 1.0a, near-miss surface-to-air missile explosions often inflicted 100%
  instant kill destruction regardless of distance or aspect.
- In 1.0e, TORNADO\DRONELIB.ASM introduces a progressive subsystem degradation
  loop (KillDamageLoop calling MaxDamage iteratively for 2 to 9 subsystem
  hits), coupled with a 20% random catastrophic threshold roll. This allows the
  player to experience emergency single-engine flight, hydraulic degradation,
  or electrical failures rather than abrupt instakills.
- TwoPlayerHit branch added for cleaner multi-player combat synchronization.
- Base Tornado radar cross section signature raised in TORNADO\AIRCRAFT.ASM
  (bp constant changed from 1,000 to 2,500).

4.10. Parachute-Retarded Ordnance & JP233 Submunition Ballistics
----------------------------------------------------------------
- In TORNADO\WEAPONS.ASM, retarded bomb and JP233 submunition physics were
  re-tuned:
  * Fixed deceleration was replaced by aerodynamic zero acceleration once
    chute equilibrium is reached.
  * WPN_ALM_TIMER set to 300, WPN_ALM_ACCEL set to 100*8 (800).
  * MOB_ANIM receives the FLAME flag on terminal ignition.

4.11. Soviet Mobile Air Defense: Strela 10 (ZREK-BD) 3D Model Replacement
-------------------------------------------------------------------------
- The older Soviet ZRK-Romb (SA-8 Gecko naval hybrid) vehicle in
  VISUAL\OBJECTS\MOBILE\ROMB.INC was completely replaced by a high-detail 3D
  model of the tracked 9K35 Strela-10 (SA-13 Gopher) short-range SAM system.
- TORNADO\PREVIEW.ASM encyclopaedia text and preview strings updated from
  "ZRK ROMB" to "STRELA 10".

4.12. External Drone Camera View: Real-Time Aircraft Designation & Callsign
---------------------------------------------------------------------------
- In 1.0a, the drone camera displayed a static "DRONE" string.
- In 1.0e (TORNADO\EXTRNPAN.ASM), FormatDroneName dynamically resolves the
  active aircraft pointer (DroneCrntPtrs) and prints the specific aircraft
  name: "TORNADO IDS", "TORNADO ADV", "F-16", "MIG-29", "SU-27", etc.
- For IDS and ADV Tornados, it dynamically looks up the flight callsign letter
  (Callsign: (A)lpha, (B)ravo, (C)harlie, etc.).

4.13. Assembler Toolchain & Instruction Encoding Portability
------------------------------------------------------------
- MASM 5.10 vs 6.11 Opcode Alignment:
  During the upgrade from MASM 5.10 to 6.11, certain ambiguous 8086 instructions
  (such as `cmp reg8, reg8` which can be encoded as either 38h or 3Ah) changed
  default opcode order. DI engineers locked down critical display and math
  routines by emitting explicit bytes:
    DB 03Ah, 0DFh ; cmp bl, bh
    DB 03Ah, 0C4h ; cmp al, ah
    DB 03Ah, 0C7h ; cmp al, bh
    DB 03Ah, 0C3h ; cmp al, bl
    DB 03Ah, 0D8h ; cmp bl, al
    DB 03Ah, 0F8h ; cmp bh, al
    DB 03Ah, 0E6h ; cmp ah, dh
  These explicit encodings occur in LIB8086\VGA_DRVR.ASM, TORNADO\HUD.ASM,
  TORNADO\MOVEMAP.ASM, TORNADO\PILOTPAN.ASM, TORNADO\PREVIEW.ASM,
  TORNADO\TAB.ASM, and VISUAL\HORIZON.ASM.


==============================================================================
5. ARCHITECTURAL DIFFERENCES: FLIGHT.EXE (EUROPE) VS DESERT.EXE (DESERT STORM)
==============================================================================
While both engines share over 90% of the simulation core, DESERT.EXE introduces
the complete Persian Gulf theater of operations with distinct terrain, units,
palettes, and memory offsets.

5.1. Theater Terrain Grids, Data Segments & Link Topologies
-----------------------------------------------------------
The linker substitution between MAIN.LNK (European) and MAIN_DS.LNK (Desert)
swaps 11 fundamental modules:

  Slot / Purpose             European (MAIN.LNK)    Desert Storm (MAIN_DS.LNK)
  ----------------------------------------------------------------------------
  Palette & Color Tables     \visual\palettes       \visual\ds_pal
  Town / Urban Geometry      \visual\towns          \visual\ds_towns
  Airfield Runways & Taxi    \visual\airfield       \visual\ds_airf
  Macro Map Grid & Heights   \visual\mapdata1       \visual\ds_map
  Sector Mesh / Surface Data \visual\secdata1       \visual\ds_secd
  Feature 3D Model Table     \visual\featobj1       \visual\ds_feat
  Ground 3D Model Table      \visual\grndobj1       \visual\ds_grnd
  Flat Surface Poly Table    \visual\flatobj1       \visual\ds_flat
  Mobile 3D Vehicle Table    \visual\mobobj1       \visual\ds_mob
  Object Preview / Briefing  preview                ds_prev
  Damage & Mob State Flags   objflags               ds_flags
  Target Executable Name     flight\flight          flight\desert

5.2. Visual Palettes, Atmospheric Lighting & Cockpit Overlays
-------------------------------------------------------------
- Cockpit Panel Art:
  In VISUAL\DS_PAL.ASM, PanelOverlay loads "GPANL_xy.RGB" (desert sand/khaki
  cockpit panel texture) instead of the European grey "PANEL_xy.RGB".
- Color Look-Up Tables:
  VGA_Palette1 in DS_PAL.ASM is re-indexed for high-noon desert sun glare,
  stark shadow falloff, beige/ochre terrain shading, burning oil well smoke
  plumes, and warm twilight haze.
- Internal Palette Section Pointers:
  * VGA_MiscPanel EQU VGA_Palette1 + 0280h  (European: +0181h)
  * VGA_HUD       EQU VGA_Palette1 + 02BFh  (European: +01C0h)
  * VGA_HUD_COLS  EQU VGA_Palette1 + 0610h  (European: +0424h)
  * VGA_Preview   EQU VGA_Palette1 + 06E2h  (European: +04F6h)

5.3. Surface Feature Encodings & Hydrological Differences
---------------------------------------------------------
- In VISUAL\FEATURES.ASM:
  * European: LAKE_FEATURE EQU 32, HARD_FEATURE1 EQU 77, HARD_FEATURE8 EQU 84
  * Desert  : LAKE_FEATURE EQU 0  (natural inland lakes absent in desert grid)
              HARD_FEATURE1 EQU 81, HARD_FEATURE8 EQU 88
- Ground Object Types (VISUAL\GNDLIST.INC):
  * Desert replaces temperate forests and copses with palm groves and oases:
    GND_COPSEA EQU 11, GND_COPSEB EQU 12, GND_COPSEC EQU 11, GND_COPSED EQU 12
  * Desert bomb craters and pipeline revetments:
    GND_CRATER1..3 EQU 67..69, GND_RBEWD / GND_RBNSD EQU 70..71,
    GND_EMBCRATER EQU 72.

5.4. Ground Defenses & Battlefield Infrastructure
-------------------------------------------------
- Airfields:
  VISUAL\DS_AIRF.ASM defines 8 fully functional military airbases modeled on
  actual Gulf War installations (Ali Al Salem, Ahmed Al Jaber, Dhahran,
  King Abdulaziz, Riyadh, Tallil, etc.), with ILS localizer/glidepath beacons
  (ILSData EQU AirfieldTable + 0F0h) and taxiway navigation waypoints
  (TaxiRoutePtrs EQU AirfieldTable + 01A0h).
- Fortified Defensive Lines:
  Over 60 miles of defensive berms, anti-tank ditches, barbed wire, and radar
  sites modeled along the Kuwait-Saudi border.
- Town Clusters:
  VISUAL\SPECIALS.ASM adjusts town generation bounds (TOWN_1 EQU 16,
  TOWN_N EQU 20), reflecting isolated desert industrial and urban centers.

5.5. Desert Storm Order of Battle, Unit Types & Drone Allocations
-----------------------------------------------------------------
- Mobile Catalog (VISUAL\MOBLIST.INC):
  New dedicated units for Operation Desert Storm:
  * Aircraft: A-10 Thunderbolt II (MOB_A10), AH-64 Apache (MOB_AH64),
    Mi-24 Hind (MOB_HIND1), Il-76 Candid (MOB_IL76), Su-27 Flanker (MOB_SU27_1),
    Su-25 Frogfoot (MOB_SU25), C-130 Hercules (MOB_C130), CH-47 Chinook (MOB_CHINOOK),
    F-16 (MOB_F16), MiG-29 (MOB_MIG29), E-3D Sentry AWACS (MOB_E3D),
    F-15C Eagle (MOB_F15), Mirage F1.
  * Armored & Support Vehicles: T-80, T-72, BMP-2, ZSU-23-4 Shilka,
    MAZ-543 Scud mobile erector/launcher, desert supply trucks, fuel tankers,
    armored locomotives and rail cars.
- Flight Envelopes:
  TORNADO\AIRCRAFT.ASM adds high-fidelity flight dynamics for the Su-27 Flanker:
    Su27Flanker PERF_DATA <Takeoff2, Cruise1, Landing2, Combat4>
    Combat4 COMBAT <100, 4, 32767, 160, 32*8>
- Drone Helicopters Disabled:
  In TORNADO\MAINDATA.ASM, DRONE_HC_ON EQU 0. Drone AI helicopters were
  disabled to conserve memory and cycles for ground armor and SAM density.
- Two-Player Mode:
  TORNADO\TWOPLYR.ASM allocates OPP_MOBILE MOBILE <24, OTYPE_MOBILE3, 0>.
- Mobile Slots:
  TORNADO\MODEL.ASM sets M_MOBILE MOBILE <23, OTYPE_MOBILE3, 0> and
  M_VIEW VIEWPOINT <16, 24, -1, -5888, 0, 0>.

5.6. Memory Layout, Data Alignment & Cross-Segment Offsets
----------------------------------------------------------
Because Desert Storm data structures contain expanded vehicle tables,
coordinates, and string pools, internal segment offsets diverge between the
two executables:
- FormatDroneName Address Offsets:
  In TORNADO\EXTRNPAN.ASM, aircraft structure references are offset by +0x10 bytes
  in Desert Storm (0911Eh, 09276h, etc.) compared to European (0910Eh, 09266h),
  and preview string offsets in PREVDATA point to desert unit names (03CCh, etc.).
- Creative Voice Driver Segment Offsets:
  In TORNADO\VOICE.ASM, segment boundary offsets for driver calls differ:
  VoiceInit, VoiceFault, VoiceVolume are located at 0D0h, 0FCh in DESERT.EXE
  versus 0E0h, 0FCh in FLIGHT.EXE.
- Relocation Table Consistency:
  Both executables maintain an identical count of 1,902 relocations.
  In both executables, relocation #1870 is emitted by DEBUG.OBJ at segment offset
  0xF5A, sandwiched between VOICETEXT and VOICELIB relocations. This requires
  linking in the exact sequence: voice+, debug+, voicelib+.


==============================================================================
6. BINARY VERIFICATION MATRIX & CHECKSUMS
==============================================================================
The table below displays the cryptographic hashes, header metadata, and binary
match results of both built executables compared to the original CD-ROM release:

------------------------------------------------------------------------------
FLIGHT.EXE (European Theater Simulation Engine, v1.0e)
------------------------------------------------------------------------------
  Target File          : TORNADO\FLIGHT\FLIGHT.EXE
  Exact File Size      : 610,000 bytes
  MD5 Hash             : 140a552910971e6e6ac3e6a976dd823a
  SHA-256 Hash         : 4a6c6dc43a140d7486737a222a4e15ebc35beb9930965e20ad4c9c804144a185
  MZ Header Checksum   : 0x030E (Offset 0x12..0x13)
  MZ Relocation Items  : 1,902
  Header Paragraphs    : 480 (0x01E0 paragraphs = 7,680 bytes)
  Byte-for-Byte Match  : 100.000000% (0 differences / 610,000 bytes)

------------------------------------------------------------------------------
DESERT.EXE (Operation Desert Storm Expansion Engine, v1.0e)
------------------------------------------------------------------------------
  Target File          : TORNADO\FLIGHT\DESERT.EXE
  Exact File Size      : 612,832 bytes
  MD5 Hash             : f6ceb08234dd1fa4759d1f39b564f52e
  SHA-256 Hash         : da57fac79f83ffdcbbdea9c88623a15d9e258c291ce6b60dd314ebc3c364086f
  MZ Header Checksum   : 0xFDC9 (Offset 0x12..0x13)
  MZ Relocation Items  : 1,902
  Header Paragraphs    : 480 (0x01E0 paragraphs = 7,680 bytes)
  Byte-for-Byte Match  : 100.000000% (0 differences / 612,832 bytes)

==============================================================================
                                END OF FILE
==============================================================================
```
