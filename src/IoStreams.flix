namespace IoStreams {

  pub enum StreamContents with Eq {
    case Str(String)
    case EOI
  }

  pub def inputStreamToChannel(in: ##java.io.InputStream): Channel[StreamContents] & Impure = {
    import new java.util.Scanner(##java.io.InputStream) as newScanner;
    let sc = newScanner(in);
    let c = chan StreamContents 0;
    spawn readLinesToChannel(sc, c);
    c
  }

  def readLinesToChannel(sc: ##java.util.Scanner, c: Channel[StreamContents]): Unit & Impure = {
    import java.util.Scanner.hasNextLine();
    import java.util.Scanner.nextLine();
    if (hasNextLine(sc)) {
      c <- Str(nextLine(sc));
      readLinesToChannel(sc, c)
    } else {
      c <- EOI;
      ()
    }
  }

  pub def outputStreamToChannel(out: ##java.io.OutputStream): Channel[StreamContents] & Impure = {
    import new java.io.PrintWriter(##java.io.OutputStream) as newPrintWriter;
    let p = newPrintWriter(out);
    let c = chan StreamContents 0;
    spawn writeLinesFromChannel(p, c);
    c
  }

  def writeLinesFromChannel(out: ##java.io.PrintWriter, c: Channel[StreamContents]): Unit & Impure = {
    import java.io.PrintWriter.println(String);
    match (<- c) {
      case Str(s) => println(out, s); writeLinesFromChannel(out, c)
      case EOI => ()
    }
  }


}