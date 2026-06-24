<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Cyclic#1">
    <Task Name="BasicDetec" Source="ExtPack._Media.BasicDetectMediaCtrl.BasicDetectMediaCtrl_v1.BasicDetectMediaCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="ThickFast" Source="ExtPack._Media.ThicknessCtrl.ThicknessCtrl_v2.ThicknessCtrl_Fast.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="VisuInks" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2">
    <Task Name="Initialize" Source="Dryer.Config.Initialize.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="InitAxis" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.InitAxisControl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Belt" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Elevation" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="InitInvert" Source="ExtPack._Motion.InverterCtrl.InverterCtrl_v1.InitInverterCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Inverter1" Source="ExtPack._Motion.InverterCtrl.InverterCtrl_v1.InverterCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="Inverter2" Source="ExtPack._Motion.InverterCtrl.InverterCtrl_v1.InverterCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3" />
  <TaskClass Name="Cyclic#4">
    <Task Name="PhyInputs" Source="Dryer.PhysicalMapping.PhysicalMapInputs.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="ThickCtrl" Source="ExtPack._Media.ThicknessCtrl.ThicknessCtrl_v2.ThicknessCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="DryerFast" Source="Dryer.DryerCtrl.DryerCtrl_Fast.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="BeltCtrl" Source="ExtPack._Transport.BeltCtrl.BeltCtrl_v1.BeltCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="InitSimple" Source="ExtPack.SimpleBlockCtrl.SimpleBlockCtrl_v1.InitSimpleBlockCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="SimpleBloc" Source="ExtPack.SimpleBlockCtrl.SimpleBlockCtrl_v1.SimpleBlockCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="InitTransV" Source="ExtPack._Transport.TransVacuumCtrl.TransVacuumCtrl_v1.InitTransVacuumCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="TransVacuu" Source="ExtPack._Transport.TransVacuumCtrl.TransVacuumCtrl_v1.TransVacuumCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="InitJamDet" Source="ExtPack._Transport.JamDetectCtrl.JamDetect_v1.InitJamDetect.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="JamDetect" Source="ExtPack._Transport.JamDetectCtrl.JamDetect_v1.JamDetect.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="ArcLampGew" Source="ExtPack._Cure.ArcLampGEW.ArcLampGew_v1.ArcLampGewCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="NIRAdphos" Source="ExtPack._Cure.NIRAdphos.NIRAdphos_v1.NIRAdphosCtrl.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="HMI" Source="Dryer.HMI.HMI.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="PhysOutput" Source="Dryer.PhysicalMapping.PhysicalMapOutputs.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#5">
    <Task Name="MachConfig" Source="Dryer.Config.MachineConfigurator.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="DryerSlow" Source="Dryer.DryerCtrl.DryerCtrl_Slow.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="ThickReadE" Source="ExtPack._Media.ThicknessCtrl.ThicknessCtrl_v2.ThickReadEnergy.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="EventLogGe" Source="ExtPack._Tools.EventLog.EventLog_v1.EventLogGen.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <Task Name="SavePerman" Source="Dryer.Config.SavePermanent.prg" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#6" />
  <NcDataObjects>
    <NcDataObject Name="AcpErrTxt" Source="AxisTables.AcpErrTxt.dob" Memory="UserROM" Language="Ett" />
    <NcDataObject Name="acp10etxen" Source="AxisTables.acp10etxen.dob" Memory="UserROM" Language="Ett" />
    <NcDataObject Name="BK1_S1400a" Source="AxisTables.BK1_S1400_a.dob" Memory="UserROM" Language="Apt" />
    <NcDataObject Name="BK1_S1400i" Source="AxisTables.BK1_S1400_i.dob" Memory="UserROM" Language="Ax" />
    <NcDataObject Name="BeltS1400a" Source="AxisTables.BeltS1400_a.dob" Memory="UserROM" Language="Apt" />
    <NcDataObject Name="BeltS1400i" Source="AxisTables.BeltS1400_i.dob" Memory="UserROM" Language="Ax" />
  </NcDataObjects>
  <Binaries>
    <BinaryObject Name="Acp10sys" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="udbdef" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="TCData" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="mvLoader" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="TCLang" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arsvcreg" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OpcUaSrv" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="acp10cfg" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Acp10map" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="iomap" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="asfw" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="Role" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="ashwac" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="sysconf" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="ashwd" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="User" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arconfig" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="EFIunits" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="EFIfunct" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="TC" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="gAlrHist" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="gAlrCore" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OpcUaMap" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
  <Libraries>
    <LibraryObject Name="Acp10sdc" Source="Libraries.Acp10sdc.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="Acp10man" Source="Libraries.Acp10man.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsBrStr" Source="Libraries.AsBrStr.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="Acp10par" Source="Libraries.Acp10par.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="NcGlobal" Source="Libraries.NcGlobal.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="Acp10_MC" Source="Libraries.Acp10_MC.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="Acp10sim" Source="Libraries.Acp10sim.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="sys_lib" Source="Libraries.sys_lib.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="brsystem" Source="Libraries.brsystem.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="operator" Source="Libraries.operator.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="runtime" Source="Libraries.runtime.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="astime" Source="Libraries.astime.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsSafety" Source="Libraries.AsSafety.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="FileIO" Source="Libraries.FileIO.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="standard" Source="Libraries.standard.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsXml" Source="Libraries.AsXml.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="asstring" Source="Libraries.asstring.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsFifo" Source="Libraries.AsFifo.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="MTTypes" Source="Libraries.MTTypes.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="MTFilter" Source="Libraries.MTFilter.lby" Memory="UserROM" Language="binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="MTBasics" Source="Libraries.MTBasics.lby" Memory="UserROM" Language="binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsTCP" Source="Libraries.AsTCP.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsIecCon" Source="Libraries.AsIecCon.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsIOAcc" Source="Libraries.AsIOAcc.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsBrMath" Source="Libraries.AsBrMath.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsEPL" Source="Libraries.AsEPL.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="ArEventLog" Source="Libraries.ArEventLog.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsARCfg" Source="Libraries.AsARCfg.lby" Memory="UserROM" Language="binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="ArProject" Source="Libraries.ArProject.lby" Memory="UserROM" Language="binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsHttp" Source="Libraries.AsHttp.lby" Memory="UserROM" Language="binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="DataObj" Source="Libraries.DataObj.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="FBs" Source="ExtPack.EFILib.EFILib_v1.FBs.lby" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="Functions" Source="ExtPack.EFILib.EFILib_v1.Functions.lby" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="ConvertFun" Source="ExtPack.EFILib.EFILib_v1.ConvertFun.lby" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="EvLogLib" Source="ExtPack._Tools.EventLog.EventLog_v1.EvLogLib.lby" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="BRSE_JSON" Source="Libraries.BRSE_JSON.lby" Memory="UserROM" Language="ANSIC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="UtMgr" Source="UnitTest.Libraries.UtMgr.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="MpAlarmX" Source="Libraries.MpAlarmX.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="MpBase" Source="Libraries.MpBase.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="MpCom" Source="Libraries.MpCom.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="MpServer" Source="Libraries.MpServer.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AxisFunc" Source="ExtPack._Motion.AxisCtrl.AxisCtrl_v2.AxisFunc.lby" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="ThickLib" Source="ExtPack._Media.ThicknessCtrl.ThickLib.lby" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="AsOpcUac" Source="Libraries.AsOpcUac.lby" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="ErrACS380" Source="Libraries.ErrACS380.lby" Memory="UserROM" Language="IEC" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="arssl" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="aruser" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="powerlnk" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="assem" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="asopcuas" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
    <LibraryObject Name="ascanopen" Source="" Memory="UserROM" Language="Binary" BuildOptions="-D _IGNORE_CHECKLIB" Debugging="true" />
  </Libraries>
</SwConfiguration>