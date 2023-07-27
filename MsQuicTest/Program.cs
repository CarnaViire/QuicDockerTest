var listener = new TestUtilities.TestEventListener("Private.InternalDiagnostics.System.Net.Quic");

var isSupported = System.Net.Quic.QuicConnection.IsSupported;
if (!isSupported)
{
    throw new Exception("[ERROR] QUIC NOT SUPPORTED ON " + System.Runtime.InteropServices.RuntimeInformation.OSDescription);
}
Console.WriteLine("QUIC support verified on " + System.Runtime.InteropServices.RuntimeInformation.OSDescription);