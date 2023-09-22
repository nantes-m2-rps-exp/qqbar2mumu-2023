
command -v nproc > /dev/null && DEFAULT_CPU=$(nproc) || DEFAULT_CPU=$(sysctl -n hw.ncpu)
DEFAULT_CPU=$(expr $DEFAULT_CPU / 2)

DEFAULT_MEM=$(cat /proc/meminfo &> /dev/null)
if [ $? -ne 0 ]; then
  # not on linux ? try macos command
  DEFAULT_MEM=$(sysctl hw.memsize | cut -d ':' -f 2)
  DEFAULT_MEM=$(expr $DEFAULT_MEM / 1024) # bytes to kB
else
  DEFAULT_MEM=$(cat /proc/meminfo | grep MemTotal | cut -d ':' -f 2 | cut -d 'k' -f 1)
fi

DEFAULT_MEM=$(expr $DEFAULT_MEM / 2)
DEFAULT_MEM="${DEFAULT_MEM}K"

NAME=${1:-qqbar2mumu}
NCORES=${2:-${DEFAULT_CPU}}
MEM=${3:-$DEFAULT_MEM}
DISK=${4:-64}

MIRROR_URL=https://cernbox.cern.ch/remote.php/dav/public-files/MIPkpzOfNpNMtXB/mirror-1.tar.gz

TARGET=haswell

if [ "$(uname -p)" == "arm" ]; then
  MIRROR_URL=https://cernbox.cern.ch/remote.php/dav/public-files/ExYwfjIYVnJbFCj/mirror-arm-1.tar.gz
  TARGET=aarch64
fi

cat cloud-init.yaml.ini | sed s+MIRROR_URL+${MIRROR_URL}+ | sed s+TARGET+${TARGET}+ > cloud-init.yaml

date > date-begin.txt

time multipass launch --name ${NAME} \
 --cpus ${NCORES} \
 --mem ${MEM} \
 --disk ${DISK}G \
 --cloud-init ./cloud-init.yaml \
 --timeout 1800

# boostrap spack by requesting a spec
time multipass exec ${NAME} -- bash -c "spack/bin/spack spec zlib"

# retrieve the public key(s) for the mirror
multipass exec ${NAME} -- bash -c "spack/bin/spack buildcache keys --install --trust"

# launch the installation (from the build cache)
time multipass exec ${NAME} -- bash -c ". ~/spack/share/spack/setup-env.sh && spack env activate ~/nantes-m2-rps-exp/qqbar2mumu-2022 && time spack install --fail-fast"

multipass transfer profile ${NAME}:.profile

date > date-end.txt

