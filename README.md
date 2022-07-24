# ABI Laboratory Docker

This is a simple container to make it easy to use the [ABI Dumper](https://github.com/lvc/abi-dumper)
alongside the [ABI Compliance Checker](https://github.com/lvc/abi-compliance-checker), both
components of the [ABI laboratory](https://abi-laboratory.pro/).

## Usage

Build the container:

```bash
$ docker build -t ghcr.io/buildsi/abi-laboratory-docker .
```

or you can just use the one that we provide on [GitHub packages](https://github.com/buildsi/abi-laboratory-docker/pkgs/container/abi-laboratory-docker):

```bash
$ docker pull ghcr.io/buildsi/abi-laboratory-docker
```

You can then mount some directory with files to check, and then target
files relative to that path in the container. As an example, knowing
that I have two versions of zlib under this root I might do:

```bash
$ new=zlib-1.2.11-3kmnsdv36qxm3slmcyrb326gkghsp6px/lib/libz.so
$ old=zlib-1.2.8-mtdthhgpvdcqsfmbqzzvdlvain56j6th/lib/libz.so
$ spack_dir=$HOME/Desktop/Code/spack-vsoch/opt/spack/linux-ubuntu20.04-skylake/gcc-9.3.0
$ docker run -it -v $spack_dir/:/data ghcr.io/buildsi/abi-laboratory-docker $old $new
```

Note that we are binding to `/data`, which also happens to be the working directory. You can also add a name:

```
$ docker run -it -v $spack_dir/:/data ghcr.io/buildsi/abi-laboratory-docker $old $new zlib
```

Here is what the output looks like!

```bash
Reading debug-info
WARNING: incompatible build option detected: -O2 (required -Og for better analysis)
Creating ABI dump

The object ABI has been dumped to:
  ABI-1.dump
Reading debug-info
WARNING: incompatible build option detected: -O2 (required -Og for better analysis)
Creating ABI dump

The object ABI has been dumped to:
  ABI-2.dump
Preparing, please wait ...
Comparing ABIs ...
Comparing APIs ...
Creating compatibility report ...
Binary compatibility: 78.6%
Source compatibility: 78.6%
Total binary compatibility problems: 2, warnings: 10
Total source compatibility problems: 1, warnings: 7
Report: compat_reports/NAME/1_to_2/compat_report.html
```

The exit code of the container is the exit code of the entrypoint, so non-zero means not abi-compatible,
and 0 means compatible (generally speaking). 

```bash
$ echo $?
1
```
Try exporting the "old" envar to be equal to new, and you'll see a zero! Finally, you can 
also interactively work in the container. Here is doing the same bind and having the entire spack install
to choose from:

```bash
$ docker run -it -v $spack_dir/:/data --entrypoint bash ghcr.io/buildsi/abi-laboratory-docker
root@6c05abfa77fd:/data# ls
automake-1.16.5-ulgibpasa7pejvmbtgccianlrux7pmtj       libxml2-2.9.12-754qa5s5kzuy3ouxthkzwuxepsornltc
berkeley-db-18.1.40-pdlzkb4o4qsw3nglppv7eqjm7lepqvod   m4-1.4.19-d4vlqx75hylz6fp4bavvuanyoblcm6jm
bzip2-1.0.8-doeyikigv6jk4dk6fdxm3cl5j7j465if           ncurses-6.2-5bzr63iqgpogufanleaw2fzjxnzziz67
cmake-3.22.2-xmfvncwibxk2v34mbqxbwnowcqdqipwj          numactl-2.0.14-xdbrc26b7oparqyw7rzrmtcbru4qx7my
```

The entrypoint script at `/entrypoint.sh` shows basic commands to dump ABI and then compare. If you want something more sophisticated (e.g., that doesn't dump the same file names to the same place) you can tweak to your liking!
It's generally designed for "one off" execution.
