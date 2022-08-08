package io.jadon.metan

import platform.darwin.KERN_VERSION

actual class Platform actual constructor() {
    actual val platform: String = "macOS $KERN_VERSION"
}