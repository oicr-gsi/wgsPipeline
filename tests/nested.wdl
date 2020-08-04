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
  Array[String] array1 = ["hi 1","hi 2","hi 3"]
  Array[String] array2 = ["4","5","6"]

  Array[Pair[String, String]] scatterInputs = cross(array1, array2)
  scatter (p in scatterInputs) {
    String message = p.left
    String second = p.right
    call printMessage {
      input:
        message=message + second,
        maybe=maybe
    }
    if (second == array2[length(array2) - 1]){
      call notify {}  # should only activate 3 times
    }
  }

  output {
    Array[String] finalOutput = printMessage.outputMessage
    Array[String] notifyOutput = notify.line
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

task notify {
  command <<<
    echo "next message reached"
  >>>
  output {
    String line = stdout()
  }
}