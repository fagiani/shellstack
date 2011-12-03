ShellStack
=====

ShellStack is a set of shell scripts that I've been collecting and creating to ease the installation of applications.

At this time, my daily working environment is based on Ubuntu Linux, therefore all scripts should work on the latest LTS versions.

Recipes
-----

Although you can use ShellStack's files separately, it has some pre cooked recipes to expedite server setup. Currently there are basically three recipes:

* basic - installs a current and secure basic box with some essential packages on it
* wordpress - install a production ready WP environment for users that have heavy traffic needs (wip)
* rails - installs a Ruby on Rails ready box based on Basic with production ready capabilities (wip)

Usage
-----

You can just source `shellstack.sh` file to source all the script files and call the functions inside the lib directory or you can also use one of the recipes listed above by issuing on terminal:

`./install <recipe>`

Contributing
-----

Please feel free to fork and send pull requests with your contributions!

Author
-----

[Paulo Fagiani](https://github.com/fagiani)

Thanks
-----

[Linode StackScripts](http://linode.com/stackscripts)

[Eric Bishop](http://github.com/ericpaulbishop)
