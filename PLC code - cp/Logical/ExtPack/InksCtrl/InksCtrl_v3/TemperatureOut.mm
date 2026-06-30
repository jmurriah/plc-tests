<map version="freeplane 1.8.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="xOutBarResistance" FOLDED="false" ID="ID_1637746323" CREATED="1600433319568" MODIFIED="1600433398333" STYLE="oval">
<font SIZE="14"/>
<hook NAME="MapStyle" zoom="0.906">
    <properties fit_to_viewport="false" show_note_icons="true" edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node" STYLE="oval" UNIFORM_SHAPE="true" VGAP_QUANTITY="24.0 pt">
<font SIZE="24"/>
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="default" ICON_SIZE="12.0 pt" COLOR="#000000" STYLE="fork">
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.attributes">
<font SIZE="9"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.note" COLOR="#000000" BACKGROUND_COLOR="#ffffff" TEXT_ALIGN="LEFT"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important">
<icon BUILTIN="yes"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000" STYLE="oval" SHAPE_HORIZONTAL_MARGIN="10.0 pt" SHAPE_VERTICAL_MARGIN="10.0 pt">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,5"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,6"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,7"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,8"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,9"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,10"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,11"/>
</stylenode>
</stylenode>
</map_styles>
</hook>
<hook NAME="AutomaticEdgeColor" COUNTER="11" RULE="ON_BRANCH_CREATION"/>
<node TEXT="SET" POSITION="right" ID="ID_323079653" CREATED="1600433355924" MODIFIED="1600433360098">
<edge COLOR="#ff0000"/>
<node TEXT="fb_PID_Temp.Out" ID="ID_1070036799" CREATED="1600439617993" MODIFIED="1600439619054">
<node TEXT="Enable" ID="ID_1540628502" CREATED="1600434927664" MODIFIED="1600434928514">
<node TEXT="AND" ID="ID_1527325632" CREATED="1600440112773" MODIFIED="1600440117607">
<node TEXT="NOT in.xTempSensorError" ID="ID_1235533920" CREATED="1600433433378" MODIFIED="1600441240253">
<node TEXT="xAlrTempSensor" ID="ID_600094438" CREATED="1600434325693" MODIFIED="1600434427204">
<icon BUILTIN="messagebox_warning"/>
<icon BUILTIN="stop"/>
<icon BUILTIN="stop-sign"/>
<node TEXT="signals.in.xTempSensorError" ID="ID_177449555" CREATED="1600438490419" MODIFIED="1600438492003"/>
<node TEXT="Timer of 2 sec" ID="ID_830460286" CREATED="1600434361536" MODIFIED="1600434366412"/>
<node TEXT="NotAutoreset" ID="ID_1704468455" CREATED="1600434126106" MODIFIED="1600434126827"/>
</node>
</node>
<node TEXT="NOT xAlrTemp" ID="ID_706774558" CREATED="1600433419925" MODIFIED="1600441252700">
<icon BUILTIN="messagebox_warning"/>
<icon BUILTIN="stop"/>
<node TEXT="inks.status.Temp.rTemp &lt; 0 OR inks.status.Temp.rTemp &gt; 100" ID="ID_859444608" CREATED="1600434017636" MODIFIED="1600434018859"/>
<node TEXT="Timer of 2seconds" ID="ID_35822412" CREATED="1600434030328" MODIFIED="1600434037925"/>
<node TEXT="NotAutoreset" ID="ID_603193904" CREATED="1600434126106" MODIFIED="1600434126827"/>
</node>
<node TEXT="xStartHeating" ID="ID_610639638" CREATED="1600433444471" MODIFIED="1600763318642">
<cloud COLOR="#f0f0f0" SHAPE="ARC"/>
<node TEXT="OR" ID="ID_1694180550" CREATED="1600434603895" MODIFIED="1600434606001">
<node TEXT="TON_HeaterStarts.Q" ID="ID_386250451" CREATED="1600434498498" MODIFIED="1600434610167">
<node ID="ID_1919889736" CREATED="1600434517586" MODIFIED="1600763158479"><richcontent TYPE="NODE">

<html>
  <head>
    
  </head>
  <body>
    <p>
      iInkState = <b>INKS_STARTING OR </b>iInkState = <b>INKS_PRIMING</b>
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="Timer 20sec" ID="ID_1147468604" CREATED="1600434525150" MODIFIED="1600434531552"/>
</node>
<node TEXT="inks.status.iInkState = INKS_STARTED" ID="ID_30426553" CREATED="1600434498498" MODIFIED="1600434614854"/>
<node TEXT=" xStateReverseFlow" ID="ID_610022677" CREATED="1600434498498" MODIFIED="1600434584946">
<node TEXT="inks.status.iInkState = INKS_MANUAL_REVERSEFLOW OR inks.status.iInkState = INKS_AUTO_REVERSEFLOW" ID="ID_747048242" CREATED="1600434542797" MODIFIED="1600434661757"/>
</node>
</node>
</node>
<node TEXT="NOT xPidTempTunning" FOLDED="true" ID="ID_459523561" CREATED="1600440248503" MODIFIED="1600763644255">
<icon BUILTIN="closed"/>
<node TEXT="Just activated during debug. No code activating it" ID="ID_839959573" CREATED="1600762346711" MODIFIED="1600763632471">
<icon BUILTIN="closed"/>
</node>
</node>
</node>
</node>
<node TEXT="HoldOut" ID="ID_430947369" CREATED="1600437142812" MODIFIED="1600437144010">
<node TEXT="OR" ID="ID_972384444" CREATED="1600438716488" MODIFIED="1600438718281">
<node TEXT="status.iDirection = INKSDIR_REVERSE" ID="ID_1197812271" CREATED="1600437158112" MODIFIED="1600438744284">
<node TEXT="inks.status.iInkState = INKS_MANUAL_REVERSEFLOW OR inks.status.iInkState = INKS_AUTO_REVERSEFLOW" ID="ID_996627453" CREATED="1600437246899" MODIFIED="1600437248721"/>
</node>
<node TEXT="xAlrKlixonTriggered" ID="ID_920864839" CREATED="1600433412274" MODIFIED="1600433946314">
<icon BUILTIN="messagebox_warning"/>
<icon BUILTIN="stop"/>
</node>
</node>
</node>
<node TEXT="SetPoint" ID="ID_1263394705" CREATED="1600437060623" MODIFIED="1600437063578">
<node TEXT="inks.parameters.Temp.rSetPointTemp" ID="ID_984490642" CREATED="1600437098857" MODIFIED="1600437105972">
<icon BUILTIN="messagebox_warning"/>
</node>
</node>
<node TEXT="ActValue" ID="ID_1982568573" CREATED="1600440319721" MODIFIED="1600440321081">
<node TEXT="status.Temp.rPresetValue" ID="ID_1609951212" CREATED="1600440330745" MODIFIED="1600440332241">
<node TEXT="status.Temp.rTemp" ID="ID_1500486527" CREATED="1600440362422" MODIFIED="1600440382973"/>
<node TEXT="rSPtemp" ID="ID_1572086712" CREATED="1600440385479" MODIFIED="1600440396318"/>
<node TEXT="K1, K2, K3, K4" ID="ID_1405417041" CREATED="1600440401782" MODIFIED="1600440409365"/>
</node>
</node>
</node>
<node TEXT="fb_PWM_Temp.Out" ID="ID_1490331667" CREATED="1600434902963" MODIFIED="1600434904707">
<node TEXT="Enable" ID="ID_185951820" CREATED="1600434927664" MODIFIED="1600434928514">
<node TEXT="xEnablePwmTemp" ID="ID_75766735" CREATED="1600434938523" MODIFIED="1600437978523">
<node TEXT="AND" ID="ID_1606073688" CREATED="1600441475082" MODIFIED="1600441478157">
<node TEXT="xStartHeating" ID="ID_1565657973" CREATED="1600434965207" MODIFIED="1600763284927">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#000000" WIDTH="5" TRANSPARENCY="120" FONT_SIZE="9" FONT_FAMILY="SansSerif" DESTINATION="ID_610639638" STARTINCLINATION="-498;0;" ENDINCLINATION="-167;58;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<cloud COLOR="#f0f0f0" SHAPE="ARC"/>
</node>
<node TEXT="OR" ID="ID_1198022991" CREATED="1600441682004" MODIFIED="1600441684448">
<node TEXT="xStartTempPwm" ID="ID_1406833380" CREATED="1600434965207" MODIFIED="1600762478891">
<node TEXT="xStartTempPwm entering on 200ms gap" ID="ID_1721704823" CREATED="1600437987415" MODIFIED="1600438042410"/>
<node TEXT="Resources??" ID="ID_81909535" CREATED="1600438043843" MODIFIED="1600438063303">
<icon BUILTIN="help"/>
<node TEXT="NO" ID="ID_1863218821" CREATED="1600762448041" MODIFIED="1600762462745">
<icon BUILTIN="closed"/>
</node>
</node>
<node TEXT="Exolanation" ID="ID_1874200832" CREATED="1600762428791" MODIFIED="1600762439250">
<node TEXT="Forced resources in EFI" ID="ID_360612575" CREATED="1600762346711" MODIFIED="1600762405002">
<icon BUILTIN="closed"/>
</node>
<node TEXT="Working OK with 99-100% Resources" ID="ID_1047713768" CREATED="1600762364067" MODIFIED="1600762385689"/>
</node>
</node>
<node TEXT="xEnablePwmTemp" ID="ID_1443053064" CREATED="1600434965207" MODIFIED="1600762500470">
<node TEXT="Just to SET the memory once started to heat" ID="ID_1040095209" CREATED="1600437987415" MODIFIED="1600441776153">
<icon BUILTIN="info"/>
</node>
</node>
</node>
</node>
</node>
</node>
<node TEXT="DutyCycle" ID="ID_1323580452" CREATED="1600434934395" MODIFIED="1600434935879">
<node TEXT="rDutyCycleTempAux" ID="ID_1495403806" CREATED="1600435023931" MODIFIED="1600435024634">
<node TEXT="status.Temp.rDutyCycleTempPowerRed" ID="ID_156148904" CREATED="1600435496759" MODIFIED="1600439883972">
<icon BUILTIN="messagebox_warning"/>
<node TEXT="MULTIP" ID="ID_321840926" CREATED="1600441796368" MODIFIED="1600441802784">
<node TEXT="status.Temp.rDutyCycleTemp" ID="ID_596887034" CREATED="1600435576888" MODIFIED="1600763587774">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#3333ff" WIDTH="5" TRANSPARENCY="140" FONT_SIZE="9" FONT_FAMILY="SansSerif" DESTINATION="ID_1070036799" STARTINCLINATION="-246;0;" ENDINCLINATION="-198;379;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<cloud COLOR="#99ccff" SHAPE="ARC"/>
</node>
<node TEXT="Temp.rReductionTempPower" ID="ID_823355483" CREATED="1600435578745" MODIFIED="1600763571903">
<icon BUILTIN="closed"/>
<node TEXT="rBlockReductionTempPower" ID="ID_934963923" CREATED="1600440478107" MODIFIED="1600441970480">
<icon BUILTIN="closed"/>
</node>
<node TEXT="Explanation" ID="ID_666587443" CREATED="1600441973956" MODIFIED="1600441980540">
<node TEXT="Affecting other bars" ID="ID_1882418370" CREATED="1600440589883" MODIFIED="1600440633598">
<icon BUILTIN="closed"/>
</node>
<node TEXT="Not heating with this value 0" ID="ID_1289723762" CREATED="1600440685176" MODIFIED="1600440699897"/>
<node TEXT="The other bars won-t heat" ID="ID_370918735" CREATED="1600440700868" MODIFIED="1600440712105"/>
</node>
</node>
</node>
</node>
</node>
</node>
</node>
</node>
<node TEXT="RESET" POSITION="right" ID="ID_1142184144" CREATED="1600433361431" MODIFIED="1600433364199">
<edge COLOR="#0000ff"/>
<node TEXT="OR" ID="ID_1651544405" CREATED="1600441018786" MODIFIED="1600441020737">
<node TEXT="NOT xStartHeating" ID="ID_1681391781" CREATED="1600433444471" MODIFIED="1600763423983">
<arrowlink SHAPE="CUBIC_CURVE" COLOR="#000000" WIDTH="5" TRANSPARENCY="140" FONT_SIZE="9" FONT_FAMILY="SansSerif" DESTINATION="ID_610639638" STARTINCLINATION="-414;-308;" ENDINCLINATION="-374;-258;" STARTARROW="NONE" ENDARROW="DEFAULT"/>
<cloud COLOR="#f0f0f0" SHAPE="ARC"/>
</node>
<node TEXT="fb_PID_Temp.HoldOut" ID="ID_1348612557" CREATED="1600762109444" MODIFIED="1600762137193">
<node TEXT="OR" ID="ID_479202426" CREATED="1600438716488" MODIFIED="1600438718281">
<node TEXT="status.iDirection = INKSDIR_REVERSE" ID="ID_1796855617" CREATED="1600437158112" MODIFIED="1600438744284">
<node TEXT="inks.status.iInkState = INKS_MANUAL_REVERSEFLOW OR inks.status.iInkState = INKS_AUTO_REVERSEFLOW" ID="ID_952207640" CREATED="1600437246899" MODIFIED="1600437248721"/>
</node>
<node TEXT="xAlrKlixonTriggered" ID="ID_1446941562" CREATED="1600433412274" MODIFIED="1600433946314">
<icon BUILTIN="messagebox_warning"/>
<icon BUILTIN="stop"/>
</node>
</node>
</node>
</node>
</node>
<node TEXT="Data in GUI or Kernel" POSITION="left" ID="ID_878519499" CREATED="1600438122101" MODIFIED="1600438559503">
<icon BUILTIN="messagebox_warning"/>
<edge COLOR="#00ff00"/>
</node>
<node TEXT="NotAutoreset" POSITION="left" ID="ID_282142818" CREATED="1600438153327" MODIFIED="1600438168623">
<icon BUILTIN="stop"/>
<edge COLOR="#ff00ff"/>
</node>
<node TEXT="Impossible" POSITION="left" ID="ID_1636294690" CREATED="1600438173268" MODIFIED="1600440643496">
<icon BUILTIN="button_cancel"/>
<edge COLOR="#00ffff"/>
</node>
<node TEXT="AlarmStopInks" POSITION="left" ID="ID_1394242675" CREATED="1600438190296" MODIFIED="1600438209662">
<icon BUILTIN="stop-sign"/>
<edge COLOR="#7c0000"/>
</node>
<node TEXT="RiskOfProblem" POSITION="left" ID="ID_645184304" CREATED="1600438212554" MODIFIED="1600438228830">
<icon BUILTIN="clanbomber"/>
<edge COLOR="#00007c"/>
</node>
<node TEXT="Hypothesis" POSITION="left" ID="ID_616270144" CREATED="1600438043843" MODIFIED="1600442561014">
<icon BUILTIN="help"/>
<edge COLOR="#007c00"/>
</node>
<node TEXT="Not possible" POSITION="left" ID="ID_597994732" CREATED="1600438173268" MODIFIED="1600440887185">
<icon BUILTIN="closed"/>
<edge COLOR="#7c007c"/>
</node>
</node>
</map>
