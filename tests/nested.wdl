version 1.0
workflow test {
  input {
    String message
    String? maybe
  }
  scatter (i in [1,2,3]) {
    scatter (y in [4,5,6]) {
      call printMessage {
        input:
          message=message,
          maybe=maybe
      }
    }
  }
}
task printMessage {
  input {
    String message
    String? maybe
  }
  command <<<
    echo "MESSAGE:"
    echo ~{message} ~{maybe}
  >>>
  output {
    String outputMessage = stdout()
  }
}