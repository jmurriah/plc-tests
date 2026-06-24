<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Cyclic#1">
    <Task Name="mappHMI" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2">
    <Task Name="Initialize" Source="Printer.Config.Initialize.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitAxisCo" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.InitAxisControl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Belt" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BK_A" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BK_B" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Stepper3L" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Gear3L" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="NoCrash1" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="NoCrash2" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitInvert" Source="ExtPack._Motion.InverterCtrl.InverterCtrl_v1.InitInverterCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Inverter1" Source="ExtPack._Motion.InverterCtrl.InverterCtrl_v1.InverterCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Inverter2" Source="ExtPack._Motion.InverterCtrl.InverterCtrl_v1.InverterCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Inverter3" Source="ExtPack._Motion.InverterCtrl.InverterCtrl_v1.InverterCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Inverter4" Source="ExtPack._Motion.InverterCtrl.InverterCtrl_v1.InverterCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitIclaSi" Source="ExtPack._Motion.IclaCtrl.IclaSim.IclaSim_v1.InitIclaSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="IclaSim1" Source="ExtPack._Motion.IclaCtrl.IclaSim.IclaSim_v1.IclaSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="IclaSim2" Source="ExtPack._Motion.IclaCtrl.IclaSim.IclaSim_v1.IclaSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="IclanLas" Source="ExtPack._Motion.IclaCtrl.IclaSim.IclaSim_v1.IclaSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="IclaEhd1" Source="ExtPack._Motion.IclaCtrl.IclaSim.IclaSim_v1.IclaSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="IclaEhd2" Source="ExtPack._Motion.IclaCtrl.IclaSim.IclaSim_v1.IclaSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="IclaEhd3" Source="ExtPack._Motion.IclaCtrl.IclaSim.IclaSim_v1.IclaSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="IclaEhd4" Source="ExtPack._Motion.IclaCtrl.IclaSim.IclaSim_v1.IclaSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SimMachFst" Source="Printer.Sim.SimMachine_Fast.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Analog_Fas" Source="ExtPack._Media.AnalogThicknessCtrl.AnalogThicknessCtrl_v1.Analog_Fast.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="nSens_Fast" Source="ExtPack._Media.nSensorCtrl.nSensorCtrl_v2.nSensorCtrl_Fast.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Thick_Fast" Source="ExtPack._Media.ThicknessCtrl.ThicknessCtrl_v2.ThicknessCtrl_Fast.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4">
    <Task Name="PhysInp" Source="Printer.PhysicalMapping.PhysicalMapInputs.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BlockInp" Source="Printer.BlockSignalsManager.BlockInputsMapping.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SimMachine" Source="Printer.Sim.SimMachine.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ThickSim" Source="ExtPack._Media.ThicknessCtrl.ThicknessCtrlSim.ThicknessCtrlSim_v1.ThicknessCtrlSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ThickPos" Source="ExtPack._Media.ThicknessCtrl.ThicknessCtrl_v2.ThicknessCtrl.prg" Memory="UserROM" Description="Thickness array manager" Language="IEC" Debugging="true" />
    <Task Name="LineCtrl" Source="LineCtrl.LineCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Mach_Fast" Source="Printer.MachineCtrl.MachineCtrl_Fast.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BeltCtrl" Source="ExtPack._Transport.BeltCtrl.BeltCtrl_v1.BeltCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitBlockC" Source="ExtPack.BlockCtrl.BlockCtrl_v1.InitBlockCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Block_BK1" Source="ExtPack.BlockCtrl.BlockCtrl_v1.BlockCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Block_BK2" Source="ExtPack.BlockCtrl.BlockCtrl_v1.BlockCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="AnalogThic" Source="ExtPack._Media.AnalogThicknessCtrl.AnalogThicknessCtrl_v1.AnalogThickness.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="nSensorCtr" Source="ExtPack._Media.nSensorCtrl.nSensorCtrl_v2.nSensorCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitChille" Source="ExtPack._Extras.ChillerCtrl.ChillerCtrl_v2.InitChiller.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Chiller1" Source="ExtPack._Extras.ChillerCtrl.ChillerCtrl_v2.ChillerCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Chiller2" Source="ExtPack._Extras.ChillerCtrl.ChillerCtrl_v2.ChillerCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitTransV" Source="ExtPack._Transport.TransVacuumCtrl.TransVacuumCtrl_v1.InitTransVacuumCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="TransVac1" Source="ExtPack._Transport.TransVacuumCtrl.TransVacuumCtrl_v1.TransVacuumCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="TransVac2" Source="ExtPack._Transport.TransVacuumCtrl.TransVacuumCtrl_v1.TransVacuumCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitNCrash" Source="ExtPack._Transport.NonCrashCtrl.NonCrashCtrl_v1.InitNonCrashCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="NonCrash1" Source="ExtPack._Transport.NonCrashCtrl.NonCrashCtrl_v1.NonCrashCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitCuring" Source="ExtPack._Cure.CuringLedCtrl.CuringLedCtrl_v1.InitCuringLedCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CuringLed1" Source="ExtPack._Cure.CuringLedCtrl.CuringLedCtrl_v1.CuringLedCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CuringLed2" Source="ExtPack._Cure.CuringLedCtrl.CuringLedCtrl_v1.CuringLedCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CuringLed3" Source="ExtPack._Cure.CuringLedCtrl.CuringLedCtrl_v1.CuringLedCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BlockOut" Source="Printer.BlockSignalsManager.BlockOutputsMapping.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PhysOut" Source="Printer.PhysicalMapping.PhysicalMapOutputs.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitTraySi" Source="ExtPack._Tools.TestBench.TraySim.TraySim_v1.InitTraySim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="TraySim1" Source="ExtPack._Tools.TestBench.TraySim.TraySim_v1.TraySim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="TraySim2" Source="ExtPack._Tools.TestBench.TraySim.TraySim_v1.TraySim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitBlockS" Source="ExtPack.BlockCtrl.BlockSim.BlockSim_v1.InitBlockSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BlockSim1" Source="ExtPack.BlockCtrl.BlockSim.BlockSim_v1.BlockSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BlockSim2" Source="ExtPack.BlockCtrl.BlockSim.BlockSim_v1.BlockSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="EhdCtrl" Source="ExtPack._Transport.EdgeHoldDown.EdgeHoldDown_v1.EdgeHoldDown.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitPaired" Source="ExtPack._Transport.PairedIclaMotors.PairedIclaMotors_v1.InitPairedIclaMotors.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PairedIcl1" Source="ExtPack._Transport.PairedIclaMotors.PairedIclaMotors_v1.PairedIclaMotors.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PairedIcl2" Source="ExtPack._Transport.PairedIclaMotors.PairedIclaMotors_v1.PairedIclaMotors.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitChilSi" Source="ExtPack._Extras.ChillerCtrl.ChillerSim.ChillerSim_v1.InitChillerSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ChillSim1" Source="ExtPack._Extras.ChillerCtrl.ChillerSim.ChillerSim_v1.ChillerSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ChillSim2" Source="ExtPack._Extras.ChillerCtrl.ChillerSim.ChillerSim_v1.ChillerSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitTrSim" Source="ExtPack._Transport.TransVacuumCtrl.TransVacuumSim.TransVacuumSim_v1.InitTransVacuumSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="TrVacSim1" Source="ExtPack._Transport.TransVacuumCtrl.TransVacuumSim.TransVacuumSim_v1.TransVacuumSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="TrVacSim2" Source="ExtPack._Transport.TransVacuumCtrl.TransVacuumSim.TransVacuumSim_v1.TransVacuumSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="TrVacSim3" Source="ExtPack._Transport.TransVacuumCtrl.TransVacuumSim.TransVacuumSim_v1.TransVacuumSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="TrVacSim4" Source="ExtPack._Transport.TransVacuumCtrl.TransVacuumSim.TransVacuumSim_v1.TransVacuumSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitCurSim" Source="ExtPack._Cure.CuringLedCtrl.CuringLedSim.CuringLedSim_v1.InitCuringLedSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CurinSim1" Source="ExtPack._Cure.CuringLedCtrl.CuringLedSim.CuringLedSim_v1.CuringLedSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CurinSim2" Source="ExtPack._Cure.CuringLedCtrl.CuringLedSim.CuringLedSim_v1.CuringLedSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="CurinSim3" Source="ExtPack._Cure.CuringLedCtrl.CuringLedSim.CuringLedSim_v1.CuringLedSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="FeederCtrl" Source="ExtPack._Ancillaries.FeederCtrl.FeederCtrl_v1.FeederCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PrimerCtrl" Source="ExtPack._Ancillaries.PrimerCtrl.PrimerCtrl_v1.PrimerCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SarmCtrl" Source="ExtPack._Ancillaries.SarmCtrl.SarmCtrl.SarmCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OpvCtrl" Source="ExtPack._Ancillaries.OpvCtrl.OpvCtrl_v1.OpvCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="StackerCtr" Source="ExtPack._Ancillaries.StackerCtrl.StackerCtrl_v1.StackerCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="DryerCtrl" Source="ExtPack._Ancillaries.DryerCtrl.DryerCtrl_v1.DryerCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="FeederSim" Source="ExtPack._Ancillaries.FeederCtrl.FeederSim.FeederSim_v1.FeederSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SarmSim" Source="ExtPack._Ancillaries.SarmCtrl.SarmSim.SarmSim_v1.SarmSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="DryerSim" Source="Dryer.DryerSimAnc.DryerSimAnc_v1.DryerSimAnc.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PrimerSim" Source="ExtPack._Ancillaries.PrimerCtrl.PrimerSim.PrimerSim_v1.PrimerSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OpvSim" Source="ExtPack._Ancillaries.OpvCtrl.OpvSim.OpvSim_v1.OpvSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SafeCtlSim" Source="ExtPack._Extras.SafetyControllerCtrl.SafetyControllerSim.SafetyControllerSim_v1.SafetyControllerSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="StackerSim" Source="ExtPack._Ancillaries.StackerCtrl.StackerSim.StackerSim_v1.StackerSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitJamDet" Source="ExtPack._Transport.JamDetectCtrl.JamDetect_v1.InitJamDetect.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="JamDetect1" Source="ExtPack._Transport.JamDetectCtrl.JamDetect_v1.JamDetect.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="JamDetect2" Source="ExtPack._Transport.JamDetectCtrl.JamDetect_v1.JamDetect.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="JamDetect3" Source="ExtPack._Transport.JamDetectCtrl.JamDetect_v1.JamDetect.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="JamDetect4" Source="ExtPack._Transport.JamDetectCtrl.JamDetect_v1.JamDetect.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitJamDeS" Source="ExtPack._Transport.JamDetectCtrl.JamDetectSim.JamDetectSim_v1.InitJamDetectSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="JamDetctS1" Source="ExtPack._Transport.JamDetectCtrl.JamDetectSim.JamDetectSim_v1.JamDetectSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="JamDetctS2" Source="ExtPack._Transport.JamDetectCtrl.JamDetectSim.JamDetectSim_v1.JamDetectSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="JamDetctS3" Source="ExtPack._Transport.JamDetectCtrl.JamDetectSim.JamDetectSim_v1.JamDetectSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="JamDetctS4" Source="ExtPack._Transport.JamDetectCtrl.JamDetectSim.JamDetectSim_v1.JamDetectSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="nSensorSim" Source="ExtPack._Media.nSensorCtrl.nSensorSim.nSensorSim_v1.nSensorSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="EhdSim" Source="ExtPack._Transport.EdgeHoldDown.EdgeHoldDownSim.EdgeHoldDownSim_v1.EdgeHoldDownSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="IniPairSim" Source="ExtPack._Transport.PairedIclaMotors.PairedIclaMotorsSim.PairedIclaMotorsSim_v1.InitPairedIclaMotorsSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PairSim" Source="ExtPack._Transport.PairedIclaMotors.PairedIclaMotorsSim.PairedIclaMotorsSim_v1.PairedIclaMotorsSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PairSim2" Source="ExtPack._Transport.PairedIclaMotors.PairedIclaMotorsSim.PairedIclaMotorsSim_v1.PairedIclaMotorsSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitNonCra" Source="ExtPack._Transport.NonCrashCtrl.NonCrashSim.NonCrashSim_v1.InitNonCrashSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="NonCrashS1" Source="ExtPack._Transport.NonCrashCtrl.NonCrashSim.NonCrashSim_v1.NonCrashSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#5">
    <Task Name="InksInputs" Source="Printer.InksSignals.InksInputs.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitInksSi" Source="ExtPack.InksCtrl.InksSim.InksSim_v1.InitInksSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InksSim01" Source="ExtPack.InksCtrl.InksSim.InksSim_v1.InksSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InksSim02" Source="ExtPack.InksCtrl.InksSim.InksSim_v1.InksSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InksSim03" Source="ExtPack.InksCtrl.InksSim.InksSim_v1.InksSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InksSim04" Source="ExtPack.InksCtrl.InksSim.InksSim_v1.InksSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InksSim05" Source="ExtPack.InksCtrl.InksSim.InksSim_v1.InksSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InksSim06" Source="ExtPack.InksCtrl.InksSim.InksSim_v1.InksSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InksSim07" Source="ExtPack.InksCtrl.InksSim.InksSim_v1.InksSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InksSim08" Source="ExtPack.InksCtrl.InksSim.InksSim_v1.InksSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitIndex" Source="ExtPack.InksCtrl.InksCtrl_v3.InitInksCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Inks_01" Source="ExtPack.InksCtrl.InksCtrl_v3.InksCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Inks_02" Source="ExtPack.InksCtrl.InksCtrl_v3.InksCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Inks_03" Source="ExtPack.InksCtrl.InksCtrl_v3.InksCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Inks_04" Source="ExtPack.InksCtrl.InksCtrl_v3.InksCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Inks_05" Source="ExtPack.InksCtrl.InksCtrl_v3.InksCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Inks_06" Source="ExtPack.InksCtrl.InksCtrl_v3.InksCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Inks_07" Source="ExtPack.InksCtrl.InksCtrl_v3.InksCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Inks_08" Source="ExtPack.InksCtrl.InksCtrl_v3.InksCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InksOutput" Source="Printer.InksSignals.InksOutputs.prg" Memory="UserROM" Description="Physical outputs inks" Language="IEC" Debugging="true" />
    <Task Name="SafetySamp" Source="AsSafetySolution.SafetySample.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="EventLogGe" Source="ExtPack._Tools.EventLog.EventLog_v1.EventLogGen.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SavePerman" Source="Printer.Config.SavePermanent.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SimUseReg" Source="ExtPack._Tools.SimUseRegister.SimUseRegister_1.SimUseRegister.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="SafetyCont" Source="ExtPack._Extras.SafetyControllerCtrl.SafetyControllerCtrl_v1.SafetyControllerCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="InitPowerM" Source="ExtPack._Extras.PowerMeterCtrl.PowerMeterCtrl_v1.InitPowerMeterCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PowerMete1" Source="ExtPack._Extras.PowerMeterCtrl.PowerMeterCtrl_v1.PowerMeterCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="PowerMete2" Source="ExtPack._Extras.PowerMeterCtrl.PowerMeterCtrl_v1.PowerMeterCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Mach_Conf" Source="Printer.Config.MachineConfigurator.prg" Memory="UserROM" Description="Printer configurator program" Language="IEC" Debugging="true" />
    <Task Name="Mach_Slow" Source="Printer.MachineCtrl.MachineCtrl_Slow.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ThickReadE" Source="ExtPack._Media.ThicknessCtrl.ThicknessCtrl_v2.ThickReadEnergy.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BeltClean" Source="ExtPack._Transport.BeltCleaning.BeltCleaning_v1.BeltCleaning.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BCleanSim" Source="ExtPack._Transport.BeltCleaning.BeltCleaningSim.BeltCleaningSim.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7">
    <Task Name="PLC2Kernel" Source="Printer.Comms.PLC2Kernel.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ServModbus" Source="ExtPack._Comms.ModbusComms.ModbusComms_v1.ServModbus.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Kernel2PLC" Source="Printer.Comms.Kernel2PLC.prg" Memory="UserROM" Description="Comns Kernel to PLC" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#8">
    <Task Name="FunctionsT" Source="UnitTest.Tests.FunctionsTests.prg" Memory="UserROM" Language="ANSIC" Debugging="true" />
    <Task Name="PrePrepare" Source="UnitTest.Tests.PrePrepare.prg" Memory="UserROM" Language="ANSIC" Debugging="true" />
    <Task Name="PrepMach" Source="UnitTest.Tests.PrepareMachine.prg" Memory="UserROM" Description="Prepare Machine to work properly in Sim" Language="ANSIC" Debugging="true" />
    <Task Name="BeltTests" Source="UnitTest.Tests.BeltTests.prg" Memory="UserROM" Language="ANSIC" Debugging="true" />
    <Task Name="ConsTests" Source="UnitTest.Tests.ConsentTests.prg" Memory="UserROM" Language="ANSIC" Debugging="true" />
    <Task Name="CleaningTe" Source="UnitTest.Tests.CleaningTests.prg" Memory="UserROM" Language="ANSIC" Debugging="true" />
    <Task Name="LineTests" Source="UnitTest.Tests.LineTests.prg" Memory="UserROM" Language="ANSIC" Debugging="true" />
    <Task Name="TrVacuumTe" Source="UnitTest.Tests.TrVacuumTests.prg" Memory="UserROM" Language="ANSIC" Debugging="true" />
    <Task Name="BlockTests" Source="UnitTest.Tests.BlockTests.prg" Memory="UserROM" Language="ANSIC" Debugging="true" />
    <Task Name="Cube" Source="UnitTest.Tests.Cube.prg" Memory="UserROM" Language="ANSIC" Debugging="true" />
  </TaskClass>
  <DataObjects>
    <DataObject Name="Acp10sys" Source="" Memory="UserROM" Language="Binary" />
  </DataObjects>
  <NcDataObjects>
    <NcDataObject Name="AcpErrTxt" Source="AxisTables.AcpErrTxt.dob" Memory="UserROM" Language="Ett" />
    <NcDataObject Name="acp10etxen" Source="AxisTables.acp10etxen.dob" Memory="UserROM" Language="Ett" />
    <NcDataObject Name="SM_a" Source="AxisTables.SM_a.dob" Memory="UserROM" Language="Apt" />
    <NcDataObject Name="SM_i" Source="AxisTables.SM_i.dob" Memory="UserROM" Language="Ax" />
    <NcDataObject Name="BeltP4_a" Source="AxisTables.BeltP4_a.dob" Memory="UserROM" Language="Apt" />
    <NcDataObject Name="BeltP4_i" Source="AxisTables.BeltP4_i.dob" Memory="UserROM" Language="Ax" />
    <NcDataObject Name="BK1_a" Source="AxisTables.BK1_a.dob" Memory="UserROM" Language="Apt" />
    <NcDataObject Name="BK1_i" Source="AxisTables.BK1_i.dob" Memory="UserROM" Language="Ax" />
    <NcDataObject Name="BK_sim_a" Source="AxisTables.BK_sim_a.dob" Memory="UserROM" Language="Apt" />
    <NcDataObject Name="NonCrash_a" Source="AxisTables.NonCrash_a.dob" Memory="UserROM" Language="Apt" />
    <NcDataObject Name="NonCrash_i" Source="AxisTables.NonCrash_i.dob" Memory="UserROM" Language="Ax" />
  </NcDataObjects>
  <VcDataObjects>
    <VcDataObject Name="SimVis" Source="Printer.Sim.SimVisu.dob" Memory="UserROM" Language="Vc" WarningLevel="2" />
    <VcDataObject Name="Panel" Source="AsSafetySolution.Panel.dob" Memory="UserROM" Language="Vc" WarningLevel="2" />
  </VcDataObjects>
  <Binaries>
    <BinaryObject Name="TCData" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="udbdef" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcfntttf" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcfile" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcshared" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcpdvnc" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcgclass" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arial" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="SimVis03" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arialxsr" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccslider" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcdsint" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="SimVis01" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccbtn" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcdsloc" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcpfar00" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccovl" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcmgr" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcctext" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcalarm" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcbclass" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcrt" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccnum" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arialbd" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccshape" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcpdsw" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcnet" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="SimVis02" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vctcal" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcpkat" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccstr" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcclbox" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccdt" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccurl" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccline" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccbar" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcchtml" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcxml" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccalarm" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcctrend" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccbmp" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccgauge" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Panel01" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Panel03" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Panel02" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccddbox" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccpopup" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="TCLang" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="mvLoader" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OpcUaSrv" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arsvcreg" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Acp10map" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="acp10cfg" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="User" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Role" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="TC" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="ashwac" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="sysconf" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="ashwd" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="arconfig" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="asfw" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="iomap" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Visu02" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Visu03" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Visu01" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Diagn02" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Diagn03" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Diagn01" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcchspot" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OpcUaMap" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
  <Libraries>
    <LibraryObject Name="UnitTest" Source="UnitTest.Libraries.UnitTest.lby" Memory="None" Language="ANSIC" Debugging="true" />
    <LibraryObject Name="LibAssert1" Source="UnitTest.Libraries.LibAssert1.lby" Memory="None" Language="ANSIC" Debugging="true" />
    <LibraryObject Name="EFIAssert" Source="UnitTest.Libraries.EFIAssert.lby" Memory="None" Language="ANSIC" Debugging="true" />
    <LibraryObject Name="UtWs" Source="UnitTest.Libraries.UtWs.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="UtMgr" Source="UnitTest.Libraries.UtMgr.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsCANopen" Source="Libraries.AsCANopen.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="FBs" Source="ExtPack.EFILib.EFILib_v1.FBs.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="Functions" Source="ExtPack.EFILib.EFILib_v1.Functions.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="ConvertFun" Source="ExtPack.EFILib.EFILib_v1.ConvertFun.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="runtime" Source="Libraries.runtime.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="brsystem" Source="Libraries.brsystem.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="sys_lib" Source="Libraries.sys_lib.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="standard" Source="Libraries.standard.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsSafety" Source="Libraries.AsSafety.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="FileIO" Source="Libraries.FileIO.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsXml" Source="Libraries.AsXml.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="astime" Source="Libraries.astime.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asstring" Source="Libraries.asstring.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsFifo" Source="Libraries.AsFifo.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="NcGlobal" Source="Libraries.NcGlobal.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsBrStr" Source="Libraries.AsBrStr.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="BRSE_MBT" Source="ExtPack._Comms.ModbusComms.ModbusComms_v1.Libraries.BRSE_MBT.lby" Memory="UserROM" Language="ANSIC" Debugging="true" />
    <LibraryObject Name="BRSE_MB" Source="ExtPack._Comms.ModbusComms.ModbusComms_v1.Libraries.BRSE_MB.lby" Memory="UserROM" Language="ANSIC" Debugging="true" />
    <LibraryObject Name="MTBasics" Source="Libraries.MTBasics.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MTTypes" Source="Libraries.MTTypes.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MTFilter" Source="Libraries.MTFilter.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsIecCon" Source="Libraries.AsIecCon.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsIOAcc" Source="Libraries.AsIOAcc.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsBrMath" Source="Libraries.AsBrMath.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsEPL" Source="Libraries.AsEPL.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="ArEventLog" Source="Libraries.ArEventLog.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="Acp10_MC" Source="Libraries.Acp10_MC.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="Acp10par" Source="Libraries.Acp10par.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="Acp10sim" Source="Libraries.Acp10sim.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="Acp10sdc" Source="Libraries.Acp10sdc.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="DataObj" Source="Libraries.DataObj.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="EvLogLib" Source="ExtPack._Tools.EventLog.EventLog_v1.EvLogLib.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="ArProject" Source="Libraries.ArProject.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AxisFunc" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisFunc.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="dvframe" Source="Libraries.dvframe.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsSem" Source="Libraries.AsSem.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="IecCheck" Source="Libraries.IecCheck.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="ThickLib" Source="ExtPack._Media.ThicknessCtrl.ThickLib.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="ErrACS380" Source="Libraries.ErrACS380.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="Acp10man" Source="Libraries.Acp10man.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpAlarmX" Source="Libraries.MpAlarmX.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpBase" Source="Libraries.MpBase.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpCom" Source="Libraries.MpCom.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpServer" Source="Libraries.MpServer.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="powerlnk" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="arssl" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="vcresman" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="ashttp" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="astcp" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asopcuac" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asopcuas" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asmath" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="aruser" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="ashw" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asarcfg" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
  </Libraries>
</SwConfiguration>