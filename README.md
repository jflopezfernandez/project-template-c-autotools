# C Language Project Template with Autotools Integration
## Introduction
This project is mean to streamline the new project creation
process by providing a modern, tested, and most importantly
premade project directory that new project developers can
simply modify to suit their needs.

### Why is a template necessary when we already have Autotools?
Well, a tool is useful if and only if people use it. Despite
the genuinely awesome functionality provided by the GNU
Autotools packages, the amount of knowledge required before
a developer can effectively make use of even the most basic
functionality could be considered prohibitive based on the
number of new projects created without integrating this
toolchain.

By using this template, the buildchain will provide the most
basic functionality from day one of the project's inception,
streamlining the process of configuring, building, and
testing new projects on a wide range of architectures and
environments. The benefits of this last point should not be
understated, as a lower barrier to entry for users on
different platforms can only help the growth of a project.

### Why not CMake?
If this project is a hammer, CMake is a nuclear fusion
reactor: both objectively cooler and significantly more
powerful. Indeed, CMake has historically lacked good 
documentation, making the task of learning how to use it
effectively about as hard as inventing an actual nuclear
fusion reactor or developing a quantum theory of gravity.

## Usage
Currently, I am using an external script to handle the
copying, renaming, and modifying of the template directories
and files.

```bash
#!/usr/bin/bash
#
# Author:
#
#   Jose Fernando Lopez Fernandez <jflopezfernandez@gmail.com>
#
# Date:
#
#   Thu Sep 17 12:26:35 PM EDT 2020
#

# Usage:
#
# TODO: Implement this usage:
#   new-project LANGUAGE NAME [DIRECTORY]
#
# For now, the only argument will be the name of the
# project, which will be created in the current
# working directory.

# Verify the user supplied the requisite number of
# arguments.
#
# These two checks could be simplified into a single
# check using [[ $# -ne 1 ]], but since the expectation
# of only a single argument is only temporary while the
# rest of the functionality is implemented, we leave
# the checks as they are. The completed program will
# require only the first check, since the program name
# will always be required, while the project language
# and location can simply be set to some sane defaults,
# such as C and the current working directory,
# respectively.
#
# TODO: Remove the second check once the functionality
# has been implemented.
#
if [[ $# -eq 0 ]] || [[ $# -gt 1 ]]
then
    # Display the help menu.
    #
    # TODO: Create the help menu.
    #
    echo 'Usage: new-project <project-name>' >&2

    # Exit with a non-zero exit status to indicate
    # something has gone awry.
    #
    exit 1
fi

# Set the project's name.
#
PROJECT="$1"

# Set the project language.
#
# TODO: Use a (possibly optional) command-line option
# to set this parameter.
#
LANGUAGE='C'

# Set the project's target location.
#
# TODO: Use an optional command-line option to set this
# parameter, with the default as the current working
# directory.
#
LOCATION=$(pwd)

# Set the target template project directory based on the
# project language.
#
TEMPLATE=""
#
# TODO: Implement C++
#
case $LANGUAGE in
    C) TEMPLATE="/home/jflopezfernandez/projects/templates/c/autotools" ;;
    *) TEMPLATE="/home/jflopezfernandez/projects/templates/c/autotools" ;;
esac

# Copy the template project into the target directory.
#
cp -rf $TEMPLATE $LOCATION/$PROJECT

# Change the current working directory into the new project
# directory.
#
cd $LOCATION/$PROJECT

# Replace every instance of 'project-name' with the name
# of the project.
#
# NOTE: These steps are pretty specific to C projects. It may be
# necessary to make this a language-specific script and
# break it off from the main project generation script.
#
for FILE in configure.ac src/main.c
do
    sed -i -E "s/(project-name)/$PROJECT/g" $FILE
done

# Rename primary project header file.
#
mv -f $LOCATION/$PROJECT/include/project-name.h $LOCATION/$PROJECT/include/$PROJECT.h
```
### Creating a New Project
Assuming the above script is located in a directory in your
`PATH` variable, simply call it with the name of your new
project as the only argument.

```bash
$ new-project happy-tunes
$ ls
happy-tunes
```
### The New Project Structure
After completing the above steps to create the new project,
`cd` into the new project's directory.
```bash
$ cd happy-tunes
$ ls
configure.ac  docs  include  LICENSE  Makefile.in  README.md  src  tests
```
While the new project does not yet conform to the GNU Coding
Standards, I plan to continue development until it does. In
the meantime, however, the current version includes a pretty
functional template already.

### Building the New Project
#### Autoconf(iguring the project)
You must run `autoreconf` bfore the newly-generated project
can be built.
```bash
$ autoreconf
$ ls
autom4te.cache  configure  configure.ac  docs  include  LICENSE  Makefile.in  README.md  src  tests
```
The iconic `configure` script has now been created, which
you can run as you normally would.
#### Configuring the Project
Run the `configure` script from the desired build directory
just as you normally would. The current version of the
project simply generates the project Makefile from the
Makefile.in file which could barely be called a template, as
much of it I hard-coded. It *is* on the list of things to
improve eventually, however.
```bash
$ ./configure
configure: creating ./config.status
config.status: creating Makefile
$ ls
autom4te.cache  config.log  config.status  configure  configure.ac  docs  include  LICENSE  Makefile  Makefile.in  README.md  src  tests
```
#### Building the Project
The project uses `make` to build the project. At the moment,
my personal preferences are hard-coded into the makefile,
but this will be corrected shortly.
```bash
gcc -std=gnu18 -Wall -Wextra -O3 -march=native -I./include -D_GNU_SOURCE -Wl,--format=elf64-x86-64 -c -o main.o src/main.c
gcc -std=gnu18 -Wall -Wextra -O3 -march=native -I./include -D_GNU_SOURCE -Wl,-O -Wl,--strip-all -Wl,--reduce-memory-overheads -Wl,--relax -Wl,--format=elf64-x86-64 main.o   -o happy-tunes
```
The project has now successfully been built, and you are
ready to begin development!
```bash
$ ./happy-tunes
testing...
```
#### Exporting a Source Archive
To export a `*.tar.gz` archive of your project, use the
`make dist` target.
```bash
$ make dist
autom4te.cache  config.log  config.status  configure  configure.ac  docs  happy-tunes-1.0.tar.gz  include  LICENSE  Makefile  Makefile.in  README.md  src  tests
```
#### Cleaning the Build Directory
The `make distclean` command will purge absolutely everything
generated by `autoconf`, `configure`, or `make`.
```bash
$ make distclean
rm -f main.o happy-tunes
rm -f configure config.log config.status Makefile
rm -rf autom4te.cache
$ ls
configure.ac  docs  happy-tunes-1.0.tar.gz  include  LICENSE  Makefile.in  README.md  src  tests
```
