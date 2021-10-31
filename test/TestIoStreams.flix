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

def stringToInputStream(s: String): ##java.io.InputStream & Impure = {
  import new java.io.ByteArrayInputStream(Array[Int8]) as newInputStream;
  import java.lang.String.getBytes();
  (s |> getBytes |> newInputStream) as ##java.io.InputStream
}