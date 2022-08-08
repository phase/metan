package io.jadon.metan

class Greeting {
    fun greeting(): String {
        return "Hello, ${Platform().platform}!"
    }
}