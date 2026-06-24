| Doc Version | Description   | Date       | Resp     |
| ----------- | ------------- | ---------- | -------- |
| 1.0         | First release | 15/05/2024 | R.Gallén |
|             |               |            |          |
|             |               |            |          |

# Related documentation

[Lexium Integrated Drive Product manual](https://efi365.sharepoint.com/:b:/r/sites/inkjet/cretaprint/oficinatecnica2/Lean%20Product%20Development/Controls/05%20Interesting%20data/ILE/ILE1B_ILE1F_ILE1R_manual_V200_logo-EN.pdf?csf=1&web=1&e=0NQaF1)

[[20220803_EHD_NZ2_DESIGN REVIEW.pptx](https://efi365.sharepoint.com/:p:/r/sites/inkjet/cretaprint/proyectos/DeLorean/Shared%20Documents/02%20R%26D,%20APP/00%20Concept/Stage2/20220803_EHD_NZ2_DESIGN%20REVIEW.pptx?d=w27b4d2092bb34d2cac40ef445c414003&csf=1&web=1&e=OYqolg)](https://efi365.sharepoint.com/:p:/r/sites/inkjet/cretaprint/proyectos/DeLorean/Shared%20Documents/02%20R%26D,%20APP/00%20Concept/Stage2/EHD_NZ2_SW_PLC_DESIGN%20REVIEW.pptx?d=w4ccdfc3dd7c74b43848b5da3ef0d8387&csf=1&web=1&e=zBDZgC)

# How to use the package

***Commands***:

| Name     | Type                   | Description                                     |
| -------- | ---------------------- | ----------------------------------------------- |
| AutoMode | stEFI_MachineAutoModes | Starts a movement in the positive direction     |
| Mode     | StGeneral_States_Mode  | Machine general modes (manual, zero, automatic) |
| Mute     | BOOL                   | Mute active alarms sound                        |
| Reset    | BOOL                   | Acknowledges and quits all errors               |
| Stop     | BOOL                   |                                                 |

**CommandsSw**:

| Name      | Type | Description                 |
| --------- | ---- | --------------------------- |
| Reference | BOOL | Sets motors homing position |

**Orders**:

| Name          | Type | Description                                                                      |
| ------------- | ---- | -------------------------------------------------------------------------------- |
| ResetPosition | BOOL | Sets resting position (metal bands on the edge of the belt) as setpoint position |
| AdjustToMedia | BOOL | Sets adjusting position (metal bands overlapping board) as setpoint position     |

**OrdersSw**:

| Name         | Type | Description                                   |
| ------------ | ---- | --------------------------------------------- |
| MoveForward  | BOOL | To move metal bands to the center of the belt |
| MoveBackward | BOOL | To move metal bands to the edge of the belt   |
| MoveUp       | BOOL | To move metal bands up                        |
| MoveDown     | BOOL | To move metal bands down                      |

**Parameters**

| Name                    | Type  | Description                                                                                      |
| ----------------------- | ----- | ------------------------------------------------------------------------------------------------ |
| Installed               | BOOL  | Physical hardware related to ehd is installed                                                    |
| EnableMovements         | BOOL  | Ehd is enabled to perform movements                                                              |
| DistanceMetalBandToSki  | REAL  | Distance (in vertical) between ski and metal band (mm)                                           |
| WidthSp                 | REAL  | Metal bands width position setpoint (mm)                                                         |
| BarsOffset              | REAL  | Offset desired between metal bands height and bars position (mm)                                 |
| BarsHeighSp             | REAL  | Bars desired printing position (mm)                                                              |
| BlockPosition           | REAL  | Bars actual position (mm)                                                                        |
| AdjustmentSystemsNumber | USINT | Number of adjustment systems used by the edge hold down. Adjust system is composed by two motors |



**Hw Parameters**

| Name                       | Type | Description                                                                                                                 |
| -------------------------- | ---- | --------------------------------------------------------------------------------------------------------------------------- |
| iMinBarsOffset             | BOOL | Minimum bars offset allowed (mm)                                                                                            |
| iMaxBarsOffset             | BOOL | Maximum bars offsetallowed (mm)                                                                                             |
| iMinOverlap                | REAL | Minimum overlap allowed (mm)                                                                                                |
| iMaxOverlap                | REAL | Maximum overlap allowed (mm)                                                                                                |
| MinWidhtAdjustment         | REAL | Distance between sliders when inductive sensor for minimum position is active (mm)                                          |
| MaxDistanceMetalBandToBelt | REAL | Limited height where ehd can be moved vertically when postioned wider than belt's widht to avoid crash with 6l chassis (mm) |



**ParSw**

| Name        | Type | Description                                                      |
| ----------- | ---- | ---------------------------------------------------------------- |
| rBarsOffset | REAL | Offset desired between metal bands height and bars position (mm) |
| iOverlap    | UINT | Overlap between metal bands and media (mm)                       |
| xEnable     | BOOL | Activated via user interface                                     |

**Status**:

| Name                     | Type | Description                                                                                                                                         |
| ------------------------ | ---- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| BlockPrePrintingPosition | REAL | Desired block position calculated depending on metal bands position                                                                                 |
| Installed                | BOOL | Physical hardware related to ehd is installed and acknowledged                                                                                      |
| Enabled                  | BOOL | Ehd object is enabled                                                                                                                               |
| Referencing              | BOOL | Referencing process is taking place                                                                                                                 |
| Referenced               | BOOL | All motors required by ehd are referenced                                                                                                           |
| InRestingPosition        | BOOL | All adjustment systems are positioned at resting position                                                                                           |
| AdjustedToMedia          | BOOL | All adjustment systems are positioned at adjusting position                                                                                         |
| Moving                   | BOOL | Any adjustment system is moving                                                                                                                     |
| Ready                    | BOOL | All adjustment system are ready to operate (no errors)                                                                                              |
| InPosition               | BOOL | All adjustment systems are positioned at desired position (this variable is always active when "InRestingPosition" or "AdjustedToMedia" are active) |
| SkiPosition              | REAL | Position of ski (heigh) in mm                                                                                                                       |
| GoingRestPosition        | BOOL | Any adjustment system is moving to resting position                                                                                                 |
| Adjusting                | BOOL | Any adjustment system is moving to adjusting position                                                                                               |

**Inputs**:

| Name | Type | Description              |
| ---- | ---- | ------------------------ |
| Jam  | BOOL | Active when jam detected |

**Alarms**

| Name                 | Type | Description                                                                       |
| -------------------- | ---- | --------------------------------------------------------------------------------- |
| ParametersOutOfRange | REAL | Active when order to adjust media received and parameters are out of requirements |
| MovementsNotEnabled  | BOOL | Active when order to adjust to media received when movements are not enabled      |
| Jam                  | BOOL | Jam sensor has detect media while ehd is adjusted to media                        |
| NotReferenced        | BOOL | Any adjustment system not referenced                                              |

# State diagram

[Machine State diagram](EdgeHoldDown.graphml)

| State   | Action                                                     | Transition                                                                        |
| ------- | ---------------------------------------------------------- | --------------------------------------------------------------------------------- |
| ERROR   | REAL                                                       | Active when order to adjust media received and parameters are out of requirements |
| STOPPED | BOOL                                                       | Zero or Not Errors                                                                |
| MANUAL  | Receptive to reference command and manual movements orders | Machine in manual mode                                                            |
| AUTO    | Auto logic executed (see AutoState table)                  | Machine in automatic mode                                                         |

| AutoState                 | Action                                                          | Transition                                                         |
| ------------------------- | --------------------------------------------------------------- | ------------------------------------------------------------------ |
| EHD_OUT_OF_AUTO           | No action executed                                              | Machine not in auto state                                          |
| EHD_MOVEMENTS_NOT_ENABLED | Stop commands sent to paired motors                             | Movements are not enabled. Stop command received. AlarmStop active |
| EHD_READY                 | Stop commands released. Sets height adjustment system position. | Movements are enabled. Adjustment systems are positioned.          |
| EHD_RESTING_STEP_1        | Sets width adjustment system position.                          | ~~"ResetPosition" order received~~                                 |
| EHD_RESTING_STEP_2        | Sets height adjustment system position.                         | Height adjustment system is positioned                             |
| EHD_RESTING_STEP_3        | No action executed                                              | Width adjustment system is positioned                              |
| EHD_ADJUSTING_STEP_1      | Sets width adjustment system position.                          | "AdjustToMedia" order received                                     |
| EHD_ADJUSTING_STEP_2      | Sets height adjustment system position.                         | Width adjustment system is positioned                              |
| EHD_ADJUSTING_STEP_3      | No action executed                                              | Width adjustment system is positioned                              |

# EHD functionality description

[Specifications](https://confluence.efi.com/pages/viewpage.action?spaceKey=NSI&title=Edge+Hold+Down+in+14000Led)
