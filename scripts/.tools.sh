command_exists() {
	command -v "$@" >/dev/null 2>&1
}

package_installed() {
	dpkg-query --list | grep -i "$@" >/dev/null 2>&1
}
