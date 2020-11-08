Class FeederBank.UnitTests
{

ClassMethod Setup(pFiles As %String = 1) As %Status
{
	Set tSC = $$$OK
	Set myNamespace = $Namespace
	Set $Namespace = "%SYS"
	//Set ^SYS("Security","CSP","AllowPrefix","/csp/dmlss_hc/","%UnitTest.")=1
	Set ^SYS("Security","CSP","AllowPrefix","/csp/healthshare/feeder/","%UnitTest.")=1
	Set $Namespace = myNamespace
	Set ^myUnitTestControl("Files") = pFiles
	Set ^myUnitTestControl("Namespace","MsgBank") = myNamespace  // MessageBank is in THIS namespace
	Set ^myUnitTestControl("Production") = "FeederBank.Production"
	Quit tSC
}

/// Use "CC" for pFiles to test CCS
ClassMethod HealthTest(pFiles As %String = 1) As %Status
{
	Do ##class(Feeder.Util).DebugTEST("FeederBank.UnitTests - HealthTest")
	Set tSC = ..Setup(pFiles)
	Set tSC = ##class(Feeder.Util).GetContainerArray(.tIRIS)
	Merge ^myUnitTestControl("IRIS") = tIRIS
	Set tIRIS = ""
	For {
		Set tIRIS = $Order(^myUnitTestControl("IRIS",tIRIS),1,tTarget)
		If (tIRIS = "") Quit
		Set ^myUnitTestControl("Server") = $Piece(tTarget,":",1)
		Set ^myUnitTestControl("Port") = $Piece(tTarget,":",2)
		Set ^UnitTestRoot = ""
		Do ##class(Feeder.TestProduction).Run()
	}
	Kill ^myUnitTestControl
	Do ##class(Feeder.Util).DebugTEST("FeederBank.UnitTests - HealthTest is done")
	Quit $$$OK
}

ClassMethod LBTest(pFiles As %String = 1, pPort As %Integer = 52773) As %Status
{
	Do ##class(Feeder.Util).DebugTEST("FeederBank.UnitTests - LBTest")
	Set tSC = ..Setup(pFiles)
	Set ^myUnitTestControl("Server") = ##class(Feeder.Util).whichLoadBalancer()
	Set ^myUnitTestControl("URL") = ##class(Feeder.Util).whichURL()
	Set ^myUnitTestControl("Port") = pPort
	Set ^UnitTestRoot = ""
	Do ##class(Feeder.TestProduction).Run()
	Kill ^myUnitTestControl
	Do ##class(Feeder.Util).DebugTEST("FeederBank.UnitTests - LBTest is done")
	Quit $$$OK
}

}
