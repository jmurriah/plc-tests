<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Cyclic#1">
    <Task Name="InitSteprs" Source="ExtPack._Motion.StepperCtrl.StepperCtrl_v1.InitStepperX2XCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Stepper3L1" Source="ExtPack._Motion.StepperCtrl.StepperCtrl_v1.StepperX2XCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Stepper3L2" Source="ExtPack._Motion.StepperCtrl.StepperCtrl_v1.StepperX2XCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Analog" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Visu_Inks" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Slave_mbus" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2">
    <Task Name="Initialize" Source="Printer.Config.Initialize.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="InitAxis" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.InitAxisControl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Belt" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="BK_A" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Stepper3L" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Gear3L" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="InitIcla" Source="ExtPack._Motion.IclaCtrl.IclaCtrl_v4.InitIclaCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="IclaBK_A" Source="ExtPack._Motion.IclaCtrl.IclaCtrl_v4.IclaCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Analog_Fas" Source="ExtPack._Media.AnalogThicknessCtrl.AnalogThicknessCtrl_v1.Analog_Fast.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="nSens_Fast" Source="ExtPack._Media.nSensorCtrl.nSensorCtrl_v2.nSensorCtrl_Fast.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Thick_Fast" Source="ExtPack._Media.ThicknessCtrl.ThicknessCtrl_v2.ThicknessCtrl_Fast.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4">
    <Task Name="PhysInput" Source="Printer.PhysicalMapping.PhysicalMapInputs.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="BlockInp" Source="Printer.BlockSignalsManager.BlockInputsMapping.prg" Memory="UserROM" Description="Physical inputs/outputs block" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="ThickPos" Source="ExtPack._Media.ThicknessCtrl.ThicknessCtrl_v2.ThicknessCtrl.prg" Memory="UserROM" Description="Thickness array manager" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Mach_Fast" Source="Printer.MachineCtrl.MachineCtrl_Fast.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="BeltCtrl" Source="ExtPack._Transport.BeltCtrl.BeltCtrl_v1.BeltCtrl.prg" Memory="UserROM" Description="Belt program" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="InitBlockC" Source="ExtPack.BlockCtrl.BlockCtrl_v1.InitBlockCtrl.prg" Memory="UserROM" Description="Init blocks" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Block_BK1" Source="ExtPack.BlockCtrl.BlockCtrl_v1.BlockCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="AnalogThic" Source="ExtPack._Media.AnalogThicknessCtrl.AnalogThicknessCtrl_v1.AnalogThickness.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="nSensorCtr" Source="ExtPack._Media.nSensorCtrl.nSensorCtrl_v2.nSensorCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="InitChille" Source="ExtPack._Extras.ChillerCtrl.ChillerCtrl_v2.InitChiller.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="ChillCtr1" Source="ExtPack._Extras.ChillerCtrl.ChillerCtrl_v2.ChillerCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="BlockOut" Source="Printer.BlockSignalsManager.BlockOutputsMapping.prg" Memory="UserROM" Description="Physical HW outputs" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="PhysOutput" Source="Printer.PhysicalMapping.PhysicalMapOutputs.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#5">
    <Task Name="InksInputs" Source="Printer.InksSignals.InksInputs.prg" Memory="UserROM" Description="Physical inputs inks" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="InitIndex" Source="ExtPack.InksCtrl.InksCtrl_v3.InitInksCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Inks_01" Source="ExtPack.InksCtrl.InksCtrl_v3.InksCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Inks_02" Source="ExtPack.InksCtrl.InksCtrl_v3.InksCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="InksOutput" Source="Printer.InksSignals.InksOutputs.prg" Memory="UserROM" Description="Physical outputs inks" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="SafetySamp" Source="AsSafetySolution.SafetySample.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="EventLogGe" Source="ExtPack._Tools.EventLog.EventLog_v1.EventLogGen.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="SavePerman" Source="Printer.Config.SavePermanent.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6">
    <Task Name="Mach_Conf" Source="Printer.Config.MachineConfigurator.prg" Memory="UserROM" Description="Printer configurator program" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Mach_Slow" Source="Printer.MachineCtrl.MachineCtrl_Slow.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#7">
    <Task Name="PLC2Kernel" Source="Printer.Comms.PLC2Kernel.prg" Memory="UserROM" Description="Comn PLC to kernel" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="ServModbus" Source="ExtPack._Comms.ModbusComms.ModbusComms_v1.ServModbus.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Kernel2PLC" Source="Printer.Comms.Kernel2PLC.prg" Memory="UserROM" Description="Comns Kernel to PLC" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#8">
    <Task Name="NwSNTPClie" Source="ExtPack._Comms.SNTPClient.SNTPClient_v1.NwSNTPClient.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" Disabled="true" />
  </TaskClass>
  <DataObjects>
    <DataObject Name="Acp10sys" Source="" Memory="UserROM" Language="Binary" />
    <DataObject Name="assl1" Source="" Memory="UserROM" Language="Binary" />
  </DataObjects>
  <NcDataObjects>
    <NcDataObject Name="AcpErrTxt" Source="AxisTables.AcpErrTxt.dob" Memory="UserROM" Description="old axis errors translation" Language="Ett" />
    <NcDataObject Name="acp10etxen" Source="AxisTables.acp10etxen.dob" Memory="UserROM" Description="axis errors translation necessary for new axis ctrl version" Language="Ett" />
    <NcDataObject Name="BeltP4_a" Source="AxisTables.BeltP4_a.dob" Memory="UserROM" Description="Axis Belt gAxis 1" Language="Apt" />
    <NcDataObject Name="BeltP4_i" Source="AxisTables.BeltP4_i.dob" Memory="UserROM" Description="Axis Belt gAxis 1 configuration" Language="Ax" />
    <NcDataObject Name="BeltShield" Source="AxisTables.BeltShield_a.dob" Memory="UserROM" Language="Apt" />
    <NcDataObject Name="BeltShiel1" Source="AxisTables.BeltShield_i.dob" Memory="UserROM" Language="Ax" />
    <NcDataObject Name="BK1_a" Source="AxisTables.BK1_a.dob" Memory="UserROM" Description="Axis Block gAxis 2 and 3 used as Block" Language="Apt" />
    <NcDataObject Name="BK1_i" Source="AxisTables.BK1_i.dob" Memory="UserROM" Description="Axis Block gAxis 2 and 3 used as Block configurations" Language="Ax" />
    <NcDataObject Name="SM_a" Source="AxisTables.SM_a.dob" Memory="UserROM" Language="Apt" />
    <NcDataObject Name="SM_i" Source="AxisTables.SM_i.dob" Memory="UserROM" Language="Ax" />
  </NcDataObjects>
  <Binaries>
    <BinaryObject Name="udbdef" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="TCData" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="mvLoader" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="TCLang" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Acp10map" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="acp10cfg" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="iomap" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="User" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="ashwac" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arconfig" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="Role" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="ashwd" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="sysconf" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="asfw" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="vccnum" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcpdvnc" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Visu02" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccalarm" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccovl" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcshared" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcfile" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Panel101" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccstr" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccline" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arial" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcpfx20" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcchtml" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcgclass" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccbtn" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcrt" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Visu03" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcctext" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcclbox" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Panel102" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccbmp" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcfntttf" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcctrend" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcalarm" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcdsint" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcnet" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccshape" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arialbd" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vctcal" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Panel103" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcmgr" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcdsloc" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Visu01" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcpkat" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccurl" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccdt" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccbar" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcpdsw" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcxml" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcbclass" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Diagn01" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccslider" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccddbox" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Diagn02" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vccpopup" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="vcchspot" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Diagn03" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
  <Libraries>
    <LibraryObject Name="AsCANopen" Source="Libraries.AsCANopen.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="FBs" Source="ExtPack.EFILib.EFILib_v1.FBs.lby" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="Functions" Source="ExtPack.EFILib.EFILib_v1.Functions.lby" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="ConvertFun" Source="ExtPack.EFILib.EFILib_v1.ConvertFun.lby" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="runtime" Source="Libraries.runtime.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="brsystem" Source="Libraries.brsystem.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="sys_lib" Source="Libraries.sys_lib.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="standard" Source="Libraries.standard.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsSafety" Source="Libraries.AsSafety.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="FileIO" Source="Libraries.FileIO.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsXml" Source="Libraries.AsXml.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="astime" Source="Libraries.astime.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="asstring" Source="Libraries.asstring.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsFifo" Source="Libraries.AsFifo.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="NcGlobal" Source="Libraries.NcGlobal.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsBrStr" Source="Libraries.AsBrStr.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="MTBasics" Source="Libraries.MTBasics.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="MTTypes" Source="Libraries.MTTypes.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="MTFilter" Source="Libraries.MTFilter.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsTCP" Source="Libraries.AsTCP.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsIecCon" Source="Libraries.AsIecCon.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsIOAcc" Source="Libraries.AsIOAcc.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsBrMath" Source="Libraries.AsBrMath.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsEPL" Source="Libraries.AsEPL.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="ArEventLog" Source="Libraries.ArEventLog.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="Acp10_MC" Source="Libraries.Acp10_MC.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="Acp10man" Source="Libraries.Acp10man.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="Acp10par" Source="Libraries.Acp10par.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="Acp10sim" Source="Libraries.Acp10sim.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="Acp10sdc" Source="Libraries.Acp10sdc.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="DataObj" Source="Libraries.DataObj.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="EvLogLib" Source="ExtPack._Tools.EventLog.EventLog_v1.EvLogLib.lby" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="BRSE_MB" Source="ExtPack._Comms.ModbusComms.ModbusComms_v1.Libraries.BRSE_MB.lby" Memory="UserROM" Language="ANSIC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="BRSE_MBT" Source="ExtPack._Comms.ModbusComms.ModbusComms_v1.Libraries.BRSE_MBT.lby" Memory="UserROM" Language="ANSIC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AxisFunc" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisFunc.lby" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsSem" Source="Libraries.AsSem.lby" Memory="UserROM" Language="binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsARCfg" Source="Libraries.AsARCfg.lby" Memory="UserROM" Language="binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="ThickLib" Source="ExtPack._Media.ThicknessCtrl.ThickLib.lby" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="powerlnk" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="arproject" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="arssl" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="asopcuas" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asopcuac" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="vcresman" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="ashw" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
  </Libraries>
</SwConfiguration>