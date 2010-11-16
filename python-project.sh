#!/usr/bin/env bash
APPNAME=$(basename "${0}")
USAGE="usage ${APPNAME} [options] projectname
  boilerplate automation for new python projects

  options:
    -a    author of the project
    -e    email of the author of the project
    -p    which python binary to target (default \"python\")

${APPNAME} needs the author and email to be set. It reads ~/.${APPNAME}rc,
which should just be a bash script setting AUTHOR and EMAIL and possibly PYTHON.

Options specified on the command line override options in the configuration
file.
"

usage() {
    echo "$USAGE"
    exit 1;
}

if [[ $# -lt 1 ]]; then
    usage 1
fi

PROJECT="$1"

if [[ -r ~/.python-projectrc ]]; then
    . ~/.python-projectrc
fi

while getopts 'a:e:p:h' arg; do
    case "${arg}" in 
        a) AUTHOR="${OPTARG}" ;;
        e) EMAIL="${OPTARG}" ;;
        p) PYTHON="{OPTARG}" ;;
        *) usage 1 ;;
    esac
done

if [[ -z "${AUTHOR}" || -z "${EMAIL}" ]]; then
    echo "AUTHOR or EMAIL needs to be set!"; usage 1
fi

if [[ -z "${PYTHON}" ]]; then
    PYTHON="python"
fi

if [[ -e "${PROJECT}" ]]; then
    echo "a file named $PROJECT exists, aborting."
fi

mkdir -p $PROJECT/{docs,$PROJECT}
cd $PROJECT

cat > README <<EOF
$PROJECT
Author: $AUTHOR <$EMAIL>
$PROJECT's README needs _filled out_!
EOF

cat > setup.py <<EOF
#!/usr/bin/env $PYTHON
import distribute_setup
distribute_setup.use_setuptools()
setup(
    name="$PROJECT",
    version="0.0.1",
    packages=['$PROJECT'],
    author="$AUTHOR",
    author_email="$EMAIL"
)
EOF

cat > .gitignore <<EOF
.#*
*pyc
*.egg-info
build/
dist/
data/
EOF

echo '#filler' > $PROJECT/__init__.py 
echo '#happy hacking' >  $PROJECT/$PROJECT.py

git init > /dev/null 2>&1
git add . > /dev/null 2>&1
git commit -m "initial commit" > /dev/null 2>&1
