version 1.0
workflow test {
  input {
    String message
    String? maybe
  }
#  scatter (i in [1,2,3]) {
#    scatter (y in [4,5,6]) {
#      call printMessage {
#        input:
#          message=message,
#          maybe=maybe
#      }
#    }
#  }

  Array[Pair[Int,Int]] scatterInputs = cross([1,2,3],[4,5,6])
  scatter (p in scatterInputs) {
    Int i = p.left
    Int y = p.right
    call printMessage {
      input:
        message=message,
        maybe=maybe
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