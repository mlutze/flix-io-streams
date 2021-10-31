use IoStreams.StreamContents;

@test
def testEmptyInputStream(): Bool & Impure = {
  let in = stringToInputStream("");
  let c = IoStreams.inputStreamToChannel(in);
  (<- c) == StreamContents.EOI
}

@test
def testOneLineInputStream(): Bool & Impure = {
  let in = stringToInputStream("abc");
  let c = IoStreams.inputStreamToChannel(in);
  (<- c) == StreamContents.Str("abc") and
    (<- c) == StreamContents.EOI
}

@test
def testTwoLineInputStream(): Bool & Impure = {
  let in = stringToInputStream("abc\ndef");
  let c = IoStreams.inputStreamToChannel(in);
  (<- c) == StreamContents.Str("abc") and
    (<- c) == StreamContents.Str("def") and
    (<- c) == StreamContents.EOI
}

@test
def testEmptyOutputStream(): Bool & Impure = {
  let out = newOutputStream();
  let c = IoStreams.outputStreamToChannel(out);
  c <- StreamContents.EOI;
  outputStreamToString(out) == ""
}

@test
def testOneLineOutputStream(): Bool & Impure = {
  let out = newOutputStream();
  let c = IoStreams.outputStreamToChannel(out);
  c <- StreamContents.Str("abc");
  c <- StreamContents.EOI;
  outputStreamToString(out) == "abc\n"
}

@test
def testTwoLineOutputStream(): Bool & Impure = {
  let out = newOutputStream();
  let c = IoStreams.outputStreamToChannel(out);
  c <- StreamContents.Str("abc");
  c <- StreamContents.Str("def");
  c <- StreamContents.EOI;
  outputStreamToString(out) == "abc\ndef\n"
}

def stringToInputStream(s: String): ##java.io.InputStream & Impure = {
  import new java.io.ByteArrayInputStream(Array[Int8]) as newInputStream;
  import java.lang.String.getBytes();
  (s |> getBytes |> newInputStream) as ##java.io.InputStream
}

def outputStreamToString(out: ##java.io.OutputStream): String & Impure = {
  import java.io.ByteArrayOutputStream.toString();
  out as ##java.io.ByteArrayOutputStream |> toString
}

def newOutputStream(): ##java.io.OutputStream & Impure = {
  import new java.io.ByteArrayOutputStream() as newStream;
  newStream() as ##java.io.OutputStream
}