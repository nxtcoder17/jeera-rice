unset shellHook
PATH=${PATH:-}
nix_saved_PATH="$PATH"
XDG_DATA_DIRS=${XDG_DATA_DIRS:-}
nix_saved_XDG_DATA_DIRS="$XDG_DATA_DIRS"
AR='ar'
export AR
AS='as'
export AS
BASH='/nix/store/rlq03x4cwf8zn73hxaxnx0zn5q9kifls-bash-5.3p3/bin/bash'
CC='gcc'
export CC
CONFIG_SHELL='/nix/store/rlq03x4cwf8zn73hxaxnx0zn5q9kifls-bash-5.3p3/bin/bash'
export CONFIG_SHELL
CXX='g++'
export CXX
DETERMINISTIC_BUILD='1'
export DETERMINISTIC_BUILD
HOSTTYPE='x86_64'
HOST_PATH='/nix/store/35yc81pz0q5yba14lxhn5r3jx5yg6c3l-bash-interactive-5.3p3/bin:/nix/store/7hvin9iffbz3krad04nsb06frc4vcznl-bat-0.26.0/bin:/nix/store/82vqj9jg3k726w7lmc2sa4zxk9ls59ym-bc-1.08.2/bin:/nix/store/a9gabjjwk0617csjlgm5f6gz5fv9jq11-bun-1.3.2/bin:/nix/store/v4q3154vdc83fxsal9syg9yppshdljyk-coreutils-full-9.8/bin:/nix/store/ikmdk37frjdblkba3wl3xws2wwgln17x-curl-8.17.0-dev/bin:/nix/store/yqnk9l97ppx2kz65wrkk5mzxi0jixkaf-brotli-1.1.0/bin:/nix/store/k09kq98k3xmjwskphhgr35bmjddqg1im-krb5-1.22.1-dev/bin:/nix/store/1byrgs1ziv2v030i1z46plpqdn7w0483-krb5-1.22.1/bin:/nix/store/x1f92dlc0m0b6ms913n7cfqi8gylhv4i-nghttp2-1.67.1/bin:/nix/store/a3v2wifbvs0wcab76006p2wgd22ci5cl-libidn2-2.3.8-bin/bin:/nix/store/k0gl1zc7f5hk87lylxwbipb0b870bcmk-openssl-3.6.0-bin/bin:/nix/store/d3fj7k3aya8slkgm72gn5izyvnlkgx73-libpsl-0.21.5/bin:/nix/store/bmdx7cg3zq7f53pl7x86v9j9b4j59cn1-zstd-1.5.7-bin/bin:/nix/store/s7vmxmhkq439cjb7ag9w198p6dk7kl0w-zstd-1.5.7/bin:/nix/store/0rfz69vp1nl0q2hxzig20hc60sk72z62-curl-8.17.0-bin/bin:/nix/store/lkdgiqh4qidry0ka5ky2fj842jnf3g35-du-dust-1.2.3/bin:/nix/store/z1h5sg9kdhkfxycz590gjxsymv9xvn0x-eza-0.23.4/bin:/nix/store/027m34av4nx0246ia2qdbfygzy9dbikw-fd-10.3.0/bin:/nix/store/lc3zmvfh5cyzdgijm8f5sjgd0q3hl9pk-fzf-0.67.0/bin:/nix/store/y12yx7z4g4a3jbzh28h6yrpvcf6px5kl-gh-2.83.1/bin:/nix/store/4qhdhmi7pzgad0zfd7c5lsg235mbf9hv-git-2.51.2/bin:/nix/store/ilh909avv5bj1hhz9iv8hsrc5pqygr2c-python3.13-git-filter-repo-2.47.0/bin:/nix/store/3lll9y925zz9393sa59h653xik66srjb-python3-3.13.9/bin:/nix/store/0a3dyfq09dnkw28ap2i450wjimvdmv6s-go-1.25.4/bin:/nix/store/874x411xcsavf0fcgrhp2bm9df3s6si0-google-chrome-142.0.7444.175/bin:/nix/store/qvbwz06cqra3cmlra40v0adw75j6j7wm-jq-1.8.1-bin/bin:/nix/store/pfkyva576bsx649x918pgysdr1rcyxzq-less-679/bin:/nix/store/p921cknvlpr9cwqwy0xdl2m9bqclq2y2-ncurses-6.5-dev/bin:/nix/store/yijhn548p2589pkybgvbhll09bqsxy0q-ncurses-6.5/bin:/nix/store/lcx3yp56z7zd0dw5g2mk7vranz07cska-nerdctl-1.7.7/bin:/nix/store/l1idqv7ff0m2kbcqnn1yr415wyga1wxf-nodejs-22.21.1-dev/bin:/nix/store/l85fis49agvp5q1ild1rfh4rrgmn92sr-nodejs-22.21.1/bin:/nix/store/8qh5h6cfwpfih87rdsnknva6jqb6sc3l-podman-5.7.0/bin:/nix/store/2fngznir58zqpvg2wl7iy5amlsbzhf9p-ripgrep-15.1.0/bin:/nix/store/lj0a1vqf1jyn90lg69bgxxkxv5s4kcx3-whereis-util-linux-2.41.2/bin:/nix/store/h7fgzg0gkpar781i0vj423sq8zyr24a5-unzip-6.0/bin:/nix/store/rwj0jbi98wrrg4c4k8a5s63cp8r7s8a9-which-2.23/bin:/nix/store/swrlnxx8q7l3a0pb4lzdlmgwxczmjp4f-wl-clipboard-2.2.1/bin:/nix/store/13d432s7zrxh43s8nrvxw2jq4sww4k3x-xdg-utils-1.2.1/bin:/nix/store/jk0qzin2yinxmfxzj03mq8pfbcgwiwrd-python3.13-yq-3.4.3/bin:/nix/store/zvi1w146j2s60jj4ss7ws5hfi8s72h9d-python3.13-argcomplete-3.6.2/bin:/nix/store/wjpwflilg7qyx5y6pgn8s1cmavs0im4n-zed-editor-0.213.3/bin:/nix/store/a5wfpm3h60lxplf2mymxfn90dp5xndb1-nvim/bin:/nix/store/v4jw5rgwqfv0v5cwqbk4ncpv672gk96m-treesitter-cli/bin:/nix/store/cfs9q5b2lq4vwayr0ir21fvm75ci31zf-patch-dynamic-loader/bin:/nix/store/imad8dvhp77h0pjbckp6wvmnyhp8dpgg-coreutils-9.8/bin:/nix/store/av4xw9f56xlx5pgv862wabfif6m1yc0a-findutils-4.10.0/bin:/nix/store/20axvl7mgj15m23jgmnq97hx37fgz7bk-diffutils-3.12/bin:/nix/store/drc7kang929jaza6cy9zdx10s4gw1z5p-gnused-4.9/bin:/nix/store/x3zjxxz8m4ki88axp0gn8q8m6bldybba-gnugrep-3.12/bin:/nix/store/y2wdhdcrffp9hnkzk06d178hq3g98jay-gawk-5.3.2/bin:/nix/store/yi3c5karhx764ham5rfwk7iynr8mjf6q-gnutar-1.35/bin:/nix/store/d471xb7sfbah076s8rx02i68zpxc2r5n-gzip-1.14/bin:/nix/store/qm9rxn2sc1vrz91i443rr6f0vxm0zd82-bzip2-1.0.8-bin/bin:/nix/store/3fmzbq9y4m9nk235il7scmvwn8j9zy3p-gnumake-4.4.1/bin:/nix/store/rlq03x4cwf8zn73hxaxnx0zn5q9kifls-bash-5.3p3/bin:/nix/store/qrwznp1ikdf0qw05wia2haiwi32ik5n0-patch-2.8/bin:/nix/store/v0rfdwhg6w6i0yb6dbry4srk6pnj3xp0-xz-5.8.1-bin/bin:/nix/store/paj6a1lpzp57hz1djm5bs86b7ci221r0-file-5.45/bin'
export HOST_PATH
IFS=' 	
'
IN_NIX_SHELL='impure'
export IN_NIX_SHELL
LD='ld'
export LD
LINENO='79'
LOCALE_ARCHIVE='/nix/store/hjlkypp9lpxwzsjycpy7nqg2mnl7qhzv-glibc-locales-2.40-66/lib/locale/locale-archive'
export LOCALE_ARCHIVE
MACHTYPE='x86_64-pc-linux-gnu'
NIX_BINTOOLS='/nix/store/xwydcyvlsa3cvssk0y5llgdhlhjvmqdm-binutils-wrapper-2.44'
export NIX_BINTOOLS
NIX_BINTOOLS_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu='1'
export NIX_BINTOOLS_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu
NIX_BUILD_CORES='16'
export NIX_BUILD_CORES
NIX_CC='/nix/store/vr15iyyykg9zai6fpgvhcgyw7gckl78w-gcc-wrapper-14.3.0'
export NIX_CC
NIX_CC_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu='1'
export NIX_CC_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu
NIX_CFLAGS_COMPILE=' -frandom-seed=9mrrpfkc19 -isystem /nix/store/35z2x1c0465xpsd1flpj8w7q0w2k5d7a-bash-interactive-5.3p3-dev/include -isystem /nix/store/ikmdk37frjdblkba3wl3xws2wwgln17x-curl-8.17.0-dev/include -isystem /nix/store/9jixqayj11r1b2r4ikrwb3kc51innr6j-brotli-1.1.0-dev/include -isystem /nix/store/yz1p4k0lbc8if7ag3cfzq7a1c3b7cca4-c-ares-1.34.5-dev/include -isystem /nix/store/k09kq98k3xmjwskphhgr35bmjddqg1im-krb5-1.22.1-dev/include -isystem /nix/store/n1rcq1pxxyc72zx2lzbrs11wy91q01bg-nghttp2-1.67.1-dev/include -isystem /nix/store/x9x748d49jjpni3sgdgva1y1qdyq6vsj-nghttp3-1.12.0-dev/include -isystem /nix/store/ws1v3raismqzcim8f9fd4ycbpr2cqk1k-ngtcp2-1.17.0-dev/include -isystem /nix/store/h02475ibf9v0mvsmrm9f8rpywqn5w196-libidn2-2.3.8-dev/include -isystem /nix/store/ydrckgnllgg8nmhdwni81h7xhcpnrlhd-openssl-3.6.0-dev/include -isystem /nix/store/s4vnadmvcv7qxbv9pv6a4csd07384cax-libpsl-0.21.5-dev/include -isystem /nix/store/yygfl7jr7nj0q9fi477bj6058h3q82p3-libssh2-1.11.1-dev/include -isystem /nix/store/hqvsiah013yzb17b13fn18fpqk7m13cg-zlib-1.3.1-dev/include -isystem /nix/store/5jbx0nr2y3b0hr0gv4np4wplzigrxhjw-zstd-1.5.7-dev/include -isystem /nix/store/3lll9y925zz9393sa59h653xik66srjb-python3-3.13.9/include -isystem /nix/store/jq07r49vk5wa10a1kk2y87nwbbl62qxz-jq-1.8.1-dev/include -isystem /nix/store/p921cknvlpr9cwqwy0xdl2m9bqclq2y2-ncurses-6.5-dev/include -isystem /nix/store/l1idqv7ff0m2kbcqnn1yr415wyga1wxf-nodejs-22.21.1-dev/include -isystem /nix/store/l85fis49agvp5q1ild1rfh4rrgmn92sr-nodejs-22.21.1/include -isystem /nix/store/35z2x1c0465xpsd1flpj8w7q0w2k5d7a-bash-interactive-5.3p3-dev/include -isystem /nix/store/ikmdk37frjdblkba3wl3xws2wwgln17x-curl-8.17.0-dev/include -isystem /nix/store/9jixqayj11r1b2r4ikrwb3kc51innr6j-brotli-1.1.0-dev/include -isystem /nix/store/yz1p4k0lbc8if7ag3cfzq7a1c3b7cca4-c-ares-1.34.5-dev/include -isystem /nix/store/k09kq98k3xmjwskphhgr35bmjddqg1im-krb5-1.22.1-dev/include -isystem /nix/store/n1rcq1pxxyc72zx2lzbrs11wy91q01bg-nghttp2-1.67.1-dev/include -isystem /nix/store/x9x748d49jjpni3sgdgva1y1qdyq6vsj-nghttp3-1.12.0-dev/include -isystem /nix/store/ws1v3raismqzcim8f9fd4ycbpr2cqk1k-ngtcp2-1.17.0-dev/include -isystem /nix/store/h02475ibf9v0mvsmrm9f8rpywqn5w196-libidn2-2.3.8-dev/include -isystem /nix/store/ydrckgnllgg8nmhdwni81h7xhcpnrlhd-openssl-3.6.0-dev/include -isystem /nix/store/s4vnadmvcv7qxbv9pv6a4csd07384cax-libpsl-0.21.5-dev/include -isystem /nix/store/yygfl7jr7nj0q9fi477bj6058h3q82p3-libssh2-1.11.1-dev/include -isystem /nix/store/hqvsiah013yzb17b13fn18fpqk7m13cg-zlib-1.3.1-dev/include -isystem /nix/store/5jbx0nr2y3b0hr0gv4np4wplzigrxhjw-zstd-1.5.7-dev/include -isystem /nix/store/3lll9y925zz9393sa59h653xik66srjb-python3-3.13.9/include -isystem /nix/store/jq07r49vk5wa10a1kk2y87nwbbl62qxz-jq-1.8.1-dev/include -isystem /nix/store/p921cknvlpr9cwqwy0xdl2m9bqclq2y2-ncurses-6.5-dev/include -isystem /nix/store/l1idqv7ff0m2kbcqnn1yr415wyga1wxf-nodejs-22.21.1-dev/include -isystem /nix/store/l85fis49agvp5q1ild1rfh4rrgmn92sr-nodejs-22.21.1/include'
export NIX_CFLAGS_COMPILE
NIX_ENFORCE_NO_NATIVE='1'
export NIX_ENFORCE_NO_NATIVE
NIX_HARDENING_ENABLE='bindnow format fortify fortify3 libcxxhardeningextensive libcxxhardeningfast pic relro stackclashprotection stackprotector strictoverflow zerocallusedregs'
export NIX_HARDENING_ENABLE
NIX_LDFLAGS='-rpath /workspace-flake/outputs/out/lib  -L/nix/store/v8czfabwiry1aik0j3b4mqkqvn7vnxfi-brotli-1.1.0-lib/lib -L/nix/store/27r2vkndmz7q6gni64l84j46igsz7km4-c-ares-1.34.5/lib -L/nix/store/9z2jg63df52gd4nmbggjcw41cdi4m14p-krb5-1.22.1-lib/lib -L/nix/store/cn8ppsx5dns0n4naa4k5sc0siymg41vw-nghttp2-1.67.1-lib/lib -L/nix/store/ggxfzhsmd3m54fac5xph7kva38k44mc2-nghttp3-1.12.0/lib -L/nix/store/50b381c1c7h4ll8a40wqh3fcknwpnnck-ngtcp2-1.17.0/lib -L/nix/store/hxcmad417fd8ql9ylx96xpak7da06yiv-libidn2-2.3.8/lib -L/nix/store/61i74yjkj9p1qphfl7018ja4sdwkipx0-openssl-3.6.0/lib -L/nix/store/d3fj7k3aya8slkgm72gn5izyvnlkgx73-libpsl-0.21.5/lib -L/nix/store/jrczm01vajmmh23wrzbgk51plwn7lfsi-libssh2-1.11.1/lib -L/nix/store/l7xwm1f6f3zj2x8jwdbi8gdyfbx07sh7-zlib-1.3.1/lib -L/nix/store/s7vmxmhkq439cjb7ag9w198p6dk7kl0w-zstd-1.5.7/lib -L/nix/store/8idis3j5l13c3x74jl8xly0k4qyk9mx6-curl-8.17.0/lib -L/nix/store/3lll9y925zz9393sa59h653xik66srjb-python3-3.13.9/lib -L/nix/store/gs6yqc24w093xsnnz3kkhls8jz7pnffy-jq-1.8.1/lib -L/nix/store/yijhn548p2589pkybgvbhll09bqsxy0q-ncurses-6.5/lib -L/nix/store/v8czfabwiry1aik0j3b4mqkqvn7vnxfi-brotli-1.1.0-lib/lib -L/nix/store/27r2vkndmz7q6gni64l84j46igsz7km4-c-ares-1.34.5/lib -L/nix/store/9z2jg63df52gd4nmbggjcw41cdi4m14p-krb5-1.22.1-lib/lib -L/nix/store/cn8ppsx5dns0n4naa4k5sc0siymg41vw-nghttp2-1.67.1-lib/lib -L/nix/store/ggxfzhsmd3m54fac5xph7kva38k44mc2-nghttp3-1.12.0/lib -L/nix/store/50b381c1c7h4ll8a40wqh3fcknwpnnck-ngtcp2-1.17.0/lib -L/nix/store/hxcmad417fd8ql9ylx96xpak7da06yiv-libidn2-2.3.8/lib -L/nix/store/61i74yjkj9p1qphfl7018ja4sdwkipx0-openssl-3.6.0/lib -L/nix/store/d3fj7k3aya8slkgm72gn5izyvnlkgx73-libpsl-0.21.5/lib -L/nix/store/jrczm01vajmmh23wrzbgk51plwn7lfsi-libssh2-1.11.1/lib -L/nix/store/l7xwm1f6f3zj2x8jwdbi8gdyfbx07sh7-zlib-1.3.1/lib -L/nix/store/s7vmxmhkq439cjb7ag9w198p6dk7kl0w-zstd-1.5.7/lib -L/nix/store/8idis3j5l13c3x74jl8xly0k4qyk9mx6-curl-8.17.0/lib -L/nix/store/3lll9y925zz9393sa59h653xik66srjb-python3-3.13.9/lib -L/nix/store/gs6yqc24w093xsnnz3kkhls8jz7pnffy-jq-1.8.1/lib -L/nix/store/yijhn548p2589pkybgvbhll09bqsxy0q-ncurses-6.5/lib'
export NIX_LDFLAGS
NIX_NO_SELF_RPATH='1'
NIX_STORE='/nix/store'
export NIX_STORE
NM='nm'
export NM
NODE_PATH='/nix/store/l85fis49agvp5q1ild1rfh4rrgmn92sr-nodejs-22.21.1/lib/node_modules'
export NODE_PATH
OBJCOPY='objcopy'
export OBJCOPY
OBJDUMP='objdump'
export OBJDUMP
OLDPWD=''
export OLDPWD
OPTERR='1'
OSTYPE='linux-gnu'
PATH='/nix/store/8q2582rd22xp8jlcg1xn1w219q5lx5xa-patchelf-0.15.2/bin:/nix/store/vr15iyyykg9zai6fpgvhcgyw7gckl78w-gcc-wrapper-14.3.0/bin:/nix/store/kzq78n13l8w24jn8bx4djj79k5j717f1-gcc-14.3.0/bin:/nix/store/q6wgv06q39bfhx2xl8ysc05wi6m2zdss-glibc-2.40-66-bin/bin:/nix/store/imad8dvhp77h0pjbckp6wvmnyhp8dpgg-coreutils-9.8/bin:/nix/store/xwydcyvlsa3cvssk0y5llgdhlhjvmqdm-binutils-wrapper-2.44/bin:/nix/store/dc9vaz50jg7mibk9xvqw5dqv89cxzla3-binutils-2.44/bin:/nix/store/35yc81pz0q5yba14lxhn5r3jx5yg6c3l-bash-interactive-5.3p3/bin:/nix/store/7hvin9iffbz3krad04nsb06frc4vcznl-bat-0.26.0/bin:/nix/store/82vqj9jg3k726w7lmc2sa4zxk9ls59ym-bc-1.08.2/bin:/nix/store/a9gabjjwk0617csjlgm5f6gz5fv9jq11-bun-1.3.2/bin:/nix/store/v4q3154vdc83fxsal9syg9yppshdljyk-coreutils-full-9.8/bin:/nix/store/ikmdk37frjdblkba3wl3xws2wwgln17x-curl-8.17.0-dev/bin:/nix/store/yqnk9l97ppx2kz65wrkk5mzxi0jixkaf-brotli-1.1.0/bin:/nix/store/k09kq98k3xmjwskphhgr35bmjddqg1im-krb5-1.22.1-dev/bin:/nix/store/1byrgs1ziv2v030i1z46plpqdn7w0483-krb5-1.22.1/bin:/nix/store/x1f92dlc0m0b6ms913n7cfqi8gylhv4i-nghttp2-1.67.1/bin:/nix/store/a3v2wifbvs0wcab76006p2wgd22ci5cl-libidn2-2.3.8-bin/bin:/nix/store/k0gl1zc7f5hk87lylxwbipb0b870bcmk-openssl-3.6.0-bin/bin:/nix/store/d3fj7k3aya8slkgm72gn5izyvnlkgx73-libpsl-0.21.5/bin:/nix/store/bmdx7cg3zq7f53pl7x86v9j9b4j59cn1-zstd-1.5.7-bin/bin:/nix/store/s7vmxmhkq439cjb7ag9w198p6dk7kl0w-zstd-1.5.7/bin:/nix/store/0rfz69vp1nl0q2hxzig20hc60sk72z62-curl-8.17.0-bin/bin:/nix/store/lkdgiqh4qidry0ka5ky2fj842jnf3g35-du-dust-1.2.3/bin:/nix/store/z1h5sg9kdhkfxycz590gjxsymv9xvn0x-eza-0.23.4/bin:/nix/store/027m34av4nx0246ia2qdbfygzy9dbikw-fd-10.3.0/bin:/nix/store/lc3zmvfh5cyzdgijm8f5sjgd0q3hl9pk-fzf-0.67.0/bin:/nix/store/y12yx7z4g4a3jbzh28h6yrpvcf6px5kl-gh-2.83.1/bin:/nix/store/4qhdhmi7pzgad0zfd7c5lsg235mbf9hv-git-2.51.2/bin:/nix/store/ilh909avv5bj1hhz9iv8hsrc5pqygr2c-python3.13-git-filter-repo-2.47.0/bin:/nix/store/3lll9y925zz9393sa59h653xik66srjb-python3-3.13.9/bin:/nix/store/0a3dyfq09dnkw28ap2i450wjimvdmv6s-go-1.25.4/bin:/nix/store/874x411xcsavf0fcgrhp2bm9df3s6si0-google-chrome-142.0.7444.175/bin:/nix/store/qvbwz06cqra3cmlra40v0adw75j6j7wm-jq-1.8.1-bin/bin:/nix/store/pfkyva576bsx649x918pgysdr1rcyxzq-less-679/bin:/nix/store/p921cknvlpr9cwqwy0xdl2m9bqclq2y2-ncurses-6.5-dev/bin:/nix/store/yijhn548p2589pkybgvbhll09bqsxy0q-ncurses-6.5/bin:/nix/store/lcx3yp56z7zd0dw5g2mk7vranz07cska-nerdctl-1.7.7/bin:/nix/store/l1idqv7ff0m2kbcqnn1yr415wyga1wxf-nodejs-22.21.1-dev/bin:/nix/store/l85fis49agvp5q1ild1rfh4rrgmn92sr-nodejs-22.21.1/bin:/nix/store/8qh5h6cfwpfih87rdsnknva6jqb6sc3l-podman-5.7.0/bin:/nix/store/2fngznir58zqpvg2wl7iy5amlsbzhf9p-ripgrep-15.1.0/bin:/nix/store/lj0a1vqf1jyn90lg69bgxxkxv5s4kcx3-whereis-util-linux-2.41.2/bin:/nix/store/h7fgzg0gkpar781i0vj423sq8zyr24a5-unzip-6.0/bin:/nix/store/rwj0jbi98wrrg4c4k8a5s63cp8r7s8a9-which-2.23/bin:/nix/store/swrlnxx8q7l3a0pb4lzdlmgwxczmjp4f-wl-clipboard-2.2.1/bin:/nix/store/13d432s7zrxh43s8nrvxw2jq4sww4k3x-xdg-utils-1.2.1/bin:/nix/store/jk0qzin2yinxmfxzj03mq8pfbcgwiwrd-python3.13-yq-3.4.3/bin:/nix/store/zvi1w146j2s60jj4ss7ws5hfi8s72h9d-python3.13-argcomplete-3.6.2/bin:/nix/store/wjpwflilg7qyx5y6pgn8s1cmavs0im4n-zed-editor-0.213.3/bin:/nix/store/a5wfpm3h60lxplf2mymxfn90dp5xndb1-nvim/bin:/nix/store/v4jw5rgwqfv0v5cwqbk4ncpv672gk96m-treesitter-cli/bin:/nix/store/cfs9q5b2lq4vwayr0ir21fvm75ci31zf-patch-dynamic-loader/bin:/nix/store/imad8dvhp77h0pjbckp6wvmnyhp8dpgg-coreutils-9.8/bin:/nix/store/av4xw9f56xlx5pgv862wabfif6m1yc0a-findutils-4.10.0/bin:/nix/store/20axvl7mgj15m23jgmnq97hx37fgz7bk-diffutils-3.12/bin:/nix/store/drc7kang929jaza6cy9zdx10s4gw1z5p-gnused-4.9/bin:/nix/store/x3zjxxz8m4ki88axp0gn8q8m6bldybba-gnugrep-3.12/bin:/nix/store/y2wdhdcrffp9hnkzk06d178hq3g98jay-gawk-5.3.2/bin:/nix/store/yi3c5karhx764ham5rfwk7iynr8mjf6q-gnutar-1.35/bin:/nix/store/d471xb7sfbah076s8rx02i68zpxc2r5n-gzip-1.14/bin:/nix/store/qm9rxn2sc1vrz91i443rr6f0vxm0zd82-bzip2-1.0.8-bin/bin:/nix/store/3fmzbq9y4m9nk235il7scmvwn8j9zy3p-gnumake-4.4.1/bin:/nix/store/rlq03x4cwf8zn73hxaxnx0zn5q9kifls-bash-5.3p3/bin:/nix/store/qrwznp1ikdf0qw05wia2haiwi32ik5n0-patch-2.8/bin:/nix/store/v0rfdwhg6w6i0yb6dbry4srk6pnj3xp0-xz-5.8.1-bin/bin:/nix/store/paj6a1lpzp57hz1djm5bs86b7ci221r0-file-5.45/bin'
export PATH
PS4='+ '
PYTHONHASHSEED='0'
export PYTHONHASHSEED
PYTHONNOUSERSITE='1'
export PYTHONNOUSERSITE
PYTHONPATH='/nix/store/ilh909avv5bj1hhz9iv8hsrc5pqygr2c-python3.13-git-filter-repo-2.47.0/lib/python3.13/site-packages:/nix/store/3lll9y925zz9393sa59h653xik66srjb-python3-3.13.9/lib/python3.13/site-packages:/nix/store/jk0qzin2yinxmfxzj03mq8pfbcgwiwrd-python3.13-yq-3.4.3/lib/python3.13/site-packages:/nix/store/zvi1w146j2s60jj4ss7ws5hfi8s72h9d-python3.13-argcomplete-3.6.2/lib/python3.13/site-packages:/nix/store/yv88fk5ya2c35gbady8ssmg3l92k4vki-python3.13-pyyaml-6.0.3/lib/python3.13/site-packages:/nix/store/j5bq6balpx7l4lhdj7z89z0xvb7w722k-python3.13-tomlkit-0.13.3/lib/python3.13/site-packages:/nix/store/0x0akdb42vrj5xykcch0fsckgaxvl2n4-python3.13-xmltodict-1.0.2/lib/python3.13/site-packages'
export PYTHONPATH
RANLIB='ranlib'
export RANLIB
READELF='readelf'
export READELF
SHELL='/nix/store/rlq03x4cwf8zn73hxaxnx0zn5q9kifls-bash-5.3p3/bin/bash'
export SHELL
SIZE='size'
export SIZE
SOURCE_DATE_EPOCH='315532800'
export SOURCE_DATE_EPOCH
STRINGS='strings'
export STRINGS
STRIP='strip'
export STRIP
XDG_DATA_DIRS='/nix/store/8q2582rd22xp8jlcg1xn1w219q5lx5xa-patchelf-0.15.2/share'
export XDG_DATA_DIRS
_PYTHON_HOST_PLATFORM='linux-x86_64'
export _PYTHON_HOST_PLATFORM
_PYTHON_SYSCONFIGDATA_NAME='_sysconfigdata__linux_x86_64-linux-gnu'
export _PYTHON_SYSCONFIGDATA_NAME
__structuredAttrs=''
export __structuredAttrs
_substituteStream_has_warned_replace_deprecation='false'
buildInputs='/nix/store/35z2x1c0465xpsd1flpj8w7q0w2k5d7a-bash-interactive-5.3p3-dev /nix/store/0sl23ayhi8bxylgxvlpxsk5yqn40hjad-bash-completion-2.17.0 /nix/store/7hvin9iffbz3krad04nsb06frc4vcznl-bat-0.26.0 /nix/store/82vqj9jg3k726w7lmc2sa4zxk9ls59ym-bc-1.08.2 /nix/store/a9gabjjwk0617csjlgm5f6gz5fv9jq11-bun-1.3.2 /nix/store/v4q3154vdc83fxsal9syg9yppshdljyk-coreutils-full-9.8 /nix/store/ikmdk37frjdblkba3wl3xws2wwgln17x-curl-8.17.0-dev /nix/store/lkdgiqh4qidry0ka5ky2fj842jnf3g35-du-dust-1.2.3 /nix/store/z1h5sg9kdhkfxycz590gjxsymv9xvn0x-eza-0.23.4 /nix/store/027m34av4nx0246ia2qdbfygzy9dbikw-fd-10.3.0 /nix/store/lc3zmvfh5cyzdgijm8f5sjgd0q3hl9pk-fzf-0.67.0 /nix/store/y12yx7z4g4a3jbzh28h6yrpvcf6px5kl-gh-2.83.1 /nix/store/4qhdhmi7pzgad0zfd7c5lsg235mbf9hv-git-2.51.2 /nix/store/ilh909avv5bj1hhz9iv8hsrc5pqygr2c-python3.13-git-filter-repo-2.47.0 /nix/store/0a3dyfq09dnkw28ap2i450wjimvdmv6s-go-1.25.4 /nix/store/874x411xcsavf0fcgrhp2bm9df3s6si0-google-chrome-142.0.7444.175 /nix/store/jq07r49vk5wa10a1kk2y87nwbbl62qxz-jq-1.8.1-dev /nix/store/pfkyva576bsx649x918pgysdr1rcyxzq-less-679 /nix/store/p921cknvlpr9cwqwy0xdl2m9bqclq2y2-ncurses-6.5-dev /nix/store/lcx3yp56z7zd0dw5g2mk7vranz07cska-nerdctl-1.7.7 /nix/store/l1idqv7ff0m2kbcqnn1yr415wyga1wxf-nodejs-22.21.1-dev /nix/store/8qh5h6cfwpfih87rdsnknva6jqb6sc3l-podman-5.7.0 /nix/store/2fngznir58zqpvg2wl7iy5amlsbzhf9p-ripgrep-15.1.0 /nix/store/lj0a1vqf1jyn90lg69bgxxkxv5s4kcx3-whereis-util-linux-2.41.2 /nix/store/h7fgzg0gkpar781i0vj423sq8zyr24a5-unzip-6.0 /nix/store/rwj0jbi98wrrg4c4k8a5s63cp8r7s8a9-which-2.23 /nix/store/swrlnxx8q7l3a0pb4lzdlmgwxczmjp4f-wl-clipboard-2.2.1 /nix/store/13d432s7zrxh43s8nrvxw2jq4sww4k3x-xdg-utils-1.2.1 /nix/store/jk0qzin2yinxmfxzj03mq8pfbcgwiwrd-python3.13-yq-3.4.3 /nix/store/wjpwflilg7qyx5y6pgn8s1cmavs0im4n-zed-editor-0.213.3 /nix/store/hjlkypp9lpxwzsjycpy7nqg2mnl7qhzv-glibc-locales-2.40-66 /nix/store/a5wfpm3h60lxplf2mymxfn90dp5xndb1-nvim /nix/store/v4jw5rgwqfv0v5cwqbk4ncpv672gk96m-treesitter-cli /nix/store/cfs9q5b2lq4vwayr0ir21fvm75ci31zf-patch-dynamic-loader'
export buildInputs
buildPhase='{ echo "------------------------------------------------------------";
  echo " WARNING: the existence of this path is not guaranteed.";
  echo " It is an internal implementation detail for pkgs.mkShell.";
  echo "------------------------------------------------------------";
  echo;
  # Record all build inputs as runtime dependencies
  export;
} >> "$out"
'
export buildPhase
builder='/nix/store/rlq03x4cwf8zn73hxaxnx0zn5q9kifls-bash-5.3p3/bin/bash'
export builder
cmakeFlags=''
export cmakeFlags
configureFlags=''
export configureFlags
defaultBuildInputs=''
defaultNativeBuildInputs='/nix/store/8q2582rd22xp8jlcg1xn1w219q5lx5xa-patchelf-0.15.2 /nix/store/l2xk4ac1wx9c95kpp8vymv9r9yn57fvh-update-autotools-gnu-config-scripts-hook /nix/store/0y5xmdb7qfvimjwbq7ibg1xdgkgjwqng-no-broken-symlinks.sh /nix/store/cv1d7p48379km6a85h4zp6kr86brh32q-audit-tmpdir.sh /nix/store/85clx3b0xkdf58jn161iy80y5223ilbi-compress-man-pages.sh /nix/store/wgrbkkaldkrlrni33ccvm3b6vbxzb656-make-symlinks-relative.sh /nix/store/5yzw0vhkyszf2d179m0qfkgxmp5wjjx4-move-docs.sh /nix/store/fyaryjvghbkpfnsyw97hb3lyb37s1pd6-move-lib64.sh /nix/store/kd4xwxjpjxi71jkm6ka0np72if9rm3y0-move-sbin.sh /nix/store/pag6l61paj1dc9sv15l7bm5c17xn5kyk-move-systemd-user-units.sh /nix/store/cmzya9irvxzlkh7lfy6i82gbp0saxqj3-multiple-outputs.sh /nix/store/x8c40nfigps493a07sdr2pm5s9j1cdc0-patch-shebangs.sh /nix/store/cickvswrvann041nqxb0rxilc46svw1n-prune-libtool-files.sh /nix/store/xyff06pkhki3qy1ls77w10s0v79c9il0-reproducible-builds.sh /nix/store/z7k98578dfzi6l3hsvbivzm7hfqlk0zc-set-source-date-epoch-to-latest.sh /nix/store/pilsssjjdxvdphlg2h19p0bfx5q0jzkn-strip.sh /nix/store/vr15iyyykg9zai6fpgvhcgyw7gckl78w-gcc-wrapper-14.3.0'
depsBuildBuild=''
export depsBuildBuild
depsBuildBuildPropagated=''
export depsBuildBuildPropagated
depsBuildTarget=''
export depsBuildTarget
depsBuildTargetPropagated=''
export depsBuildTargetPropagated
depsHostHost=''
export depsHostHost
depsHostHostPropagated=''
export depsHostHostPropagated
depsTargetTarget=''
export depsTargetTarget
depsTargetTargetPropagated=''
export depsTargetTargetPropagated
doCheck=''
export doCheck
doInstallCheck=''
export doInstallCheck
dontAddDisableDepTrack='1'
export dontAddDisableDepTrack
declare -a envBuildBuildHooks=()
declare -a envBuildHostHooks=()
declare -a envBuildTargetHooks=()
declare -a envHostHostHooks=('ccWrapper_addCVars' 'bintoolsWrapper_addLDVars' 'addPythonPath' 'sysconfigdataHook' 'addNodePath' )
declare -a envHostTargetHooks=('ccWrapper_addCVars' 'bintoolsWrapper_addLDVars' 'addPythonPath' 'sysconfigdataHook' 'addNodePath' )
declare -a envTargetTargetHooks=()
declare -a fixupOutputHooks=('if [ -z "${dontPatchELF-}" ]; then patchELF "$prefix"; fi' 'if [[ -z "${noAuditTmpdir-}" && -e "$prefix" ]]; then auditTmpdir "$prefix"; fi' 'if [ -z "${dontGzipMan-}" ]; then compressManPages "$prefix"; fi' '_moveLib64' '_moveSbin' '_moveSystemdUserUnits' 'patchShebangsAuto' '_pruneLibtoolFiles' '_doStrip' )
initialPath='/nix/store/imad8dvhp77h0pjbckp6wvmnyhp8dpgg-coreutils-9.8 /nix/store/av4xw9f56xlx5pgv862wabfif6m1yc0a-findutils-4.10.0 /nix/store/20axvl7mgj15m23jgmnq97hx37fgz7bk-diffutils-3.12 /nix/store/drc7kang929jaza6cy9zdx10s4gw1z5p-gnused-4.9 /nix/store/x3zjxxz8m4ki88axp0gn8q8m6bldybba-gnugrep-3.12 /nix/store/y2wdhdcrffp9hnkzk06d178hq3g98jay-gawk-5.3.2 /nix/store/yi3c5karhx764ham5rfwk7iynr8mjf6q-gnutar-1.35 /nix/store/d471xb7sfbah076s8rx02i68zpxc2r5n-gzip-1.14 /nix/store/qm9rxn2sc1vrz91i443rr6f0vxm0zd82-bzip2-1.0.8-bin /nix/store/3fmzbq9y4m9nk235il7scmvwn8j9zy3p-gnumake-4.4.1 /nix/store/rlq03x4cwf8zn73hxaxnx0zn5q9kifls-bash-5.3p3 /nix/store/qrwznp1ikdf0qw05wia2haiwi32ik5n0-patch-2.8 /nix/store/v0rfdwhg6w6i0yb6dbry4srk6pnj3xp0-xz-5.8.1-bin /nix/store/paj6a1lpzp57hz1djm5bs86b7ci221r0-file-5.45'
mesonFlags=''
export mesonFlags
name='nix-shell-env'
export name
nativeBuildInputs=''
export nativeBuildInputs
out='/workspace-flake/outputs/out'
export out
outputBin='out'
outputDev='out'
outputDevdoc='REMOVE'
outputDevman='out'
outputDoc='out'
outputInclude='out'
outputInfo='out'
outputLib='out'
outputMan='out'
outputs='out'
export outputs
patches=''
export patches
phases='buildPhase'
export phases
pkg='/nix/store/vr15iyyykg9zai6fpgvhcgyw7gckl78w-gcc-wrapper-14.3.0'
declare -a pkgsBuildBuild=()
declare -a pkgsBuildHost=('/nix/store/8q2582rd22xp8jlcg1xn1w219q5lx5xa-patchelf-0.15.2' '/nix/store/l2xk4ac1wx9c95kpp8vymv9r9yn57fvh-update-autotools-gnu-config-scripts-hook' '/nix/store/0y5xmdb7qfvimjwbq7ibg1xdgkgjwqng-no-broken-symlinks.sh' '/nix/store/cv1d7p48379km6a85h4zp6kr86brh32q-audit-tmpdir.sh' '/nix/store/85clx3b0xkdf58jn161iy80y5223ilbi-compress-man-pages.sh' '/nix/store/wgrbkkaldkrlrni33ccvm3b6vbxzb656-make-symlinks-relative.sh' '/nix/store/5yzw0vhkyszf2d179m0qfkgxmp5wjjx4-move-docs.sh' '/nix/store/fyaryjvghbkpfnsyw97hb3lyb37s1pd6-move-lib64.sh' '/nix/store/kd4xwxjpjxi71jkm6ka0np72if9rm3y0-move-sbin.sh' '/nix/store/pag6l61paj1dc9sv15l7bm5c17xn5kyk-move-systemd-user-units.sh' '/nix/store/cmzya9irvxzlkh7lfy6i82gbp0saxqj3-multiple-outputs.sh' '/nix/store/x8c40nfigps493a07sdr2pm5s9j1cdc0-patch-shebangs.sh' '/nix/store/cickvswrvann041nqxb0rxilc46svw1n-prune-libtool-files.sh' '/nix/store/xyff06pkhki3qy1ls77w10s0v79c9il0-reproducible-builds.sh' '/nix/store/z7k98578dfzi6l3hsvbivzm7hfqlk0zc-set-source-date-epoch-to-latest.sh' '/nix/store/pilsssjjdxvdphlg2h19p0bfx5q0jzkn-strip.sh' '/nix/store/vr15iyyykg9zai6fpgvhcgyw7gckl78w-gcc-wrapper-14.3.0' '/nix/store/xwydcyvlsa3cvssk0y5llgdhlhjvmqdm-binutils-wrapper-2.44' )
declare -a pkgsBuildTarget=()
declare -a pkgsHostHost=()
declare -a pkgsHostTarget=('/nix/store/35z2x1c0465xpsd1flpj8w7q0w2k5d7a-bash-interactive-5.3p3-dev' '/nix/store/35yc81pz0q5yba14lxhn5r3jx5yg6c3l-bash-interactive-5.3p3' '/nix/store/0sl23ayhi8bxylgxvlpxsk5yqn40hjad-bash-completion-2.17.0' '/nix/store/7hvin9iffbz3krad04nsb06frc4vcznl-bat-0.26.0' '/nix/store/82vqj9jg3k726w7lmc2sa4zxk9ls59ym-bc-1.08.2' '/nix/store/a9gabjjwk0617csjlgm5f6gz5fv9jq11-bun-1.3.2' '/nix/store/v4q3154vdc83fxsal9syg9yppshdljyk-coreutils-full-9.8' '/nix/store/ikmdk37frjdblkba3wl3xws2wwgln17x-curl-8.17.0-dev' '/nix/store/9jixqayj11r1b2r4ikrwb3kc51innr6j-brotli-1.1.0-dev' '/nix/store/v8czfabwiry1aik0j3b4mqkqvn7vnxfi-brotli-1.1.0-lib' '/nix/store/yqnk9l97ppx2kz65wrkk5mzxi0jixkaf-brotli-1.1.0' '/nix/store/yz1p4k0lbc8if7ag3cfzq7a1c3b7cca4-c-ares-1.34.5-dev' '/nix/store/27r2vkndmz7q6gni64l84j46igsz7km4-c-ares-1.34.5' '/nix/store/k09kq98k3xmjwskphhgr35bmjddqg1im-krb5-1.22.1-dev' '/nix/store/9z2jg63df52gd4nmbggjcw41cdi4m14p-krb5-1.22.1-lib' '/nix/store/1byrgs1ziv2v030i1z46plpqdn7w0483-krb5-1.22.1' '/nix/store/n1rcq1pxxyc72zx2lzbrs11wy91q01bg-nghttp2-1.67.1-dev' '/nix/store/cn8ppsx5dns0n4naa4k5sc0siymg41vw-nghttp2-1.67.1-lib' '/nix/store/x1f92dlc0m0b6ms913n7cfqi8gylhv4i-nghttp2-1.67.1' '/nix/store/x9x748d49jjpni3sgdgva1y1qdyq6vsj-nghttp3-1.12.0-dev' '/nix/store/ggxfzhsmd3m54fac5xph7kva38k44mc2-nghttp3-1.12.0' '/nix/store/ws1v3raismqzcim8f9fd4ycbpr2cqk1k-ngtcp2-1.17.0-dev' '/nix/store/50b381c1c7h4ll8a40wqh3fcknwpnnck-ngtcp2-1.17.0' '/nix/store/h02475ibf9v0mvsmrm9f8rpywqn5w196-libidn2-2.3.8-dev' '/nix/store/a3v2wifbvs0wcab76006p2wgd22ci5cl-libidn2-2.3.8-bin' '/nix/store/hxcmad417fd8ql9ylx96xpak7da06yiv-libidn2-2.3.8' '/nix/store/ydrckgnllgg8nmhdwni81h7xhcpnrlhd-openssl-3.6.0-dev' '/nix/store/k0gl1zc7f5hk87lylxwbipb0b870bcmk-openssl-3.6.0-bin' '/nix/store/61i74yjkj9p1qphfl7018ja4sdwkipx0-openssl-3.6.0' '/nix/store/s4vnadmvcv7qxbv9pv6a4csd07384cax-libpsl-0.21.5-dev' '/nix/store/1rd1dikwmy9gnlk5911gf2wf5r8k9wdg-publicsuffix-list-0-unstable-2025-10-08' '/nix/store/d3fj7k3aya8slkgm72gn5izyvnlkgx73-libpsl-0.21.5' '/nix/store/yygfl7jr7nj0q9fi477bj6058h3q82p3-libssh2-1.11.1-dev' '/nix/store/jrczm01vajmmh23wrzbgk51plwn7lfsi-libssh2-1.11.1' '/nix/store/hqvsiah013yzb17b13fn18fpqk7m13cg-zlib-1.3.1-dev' '/nix/store/l7xwm1f6f3zj2x8jwdbi8gdyfbx07sh7-zlib-1.3.1' '/nix/store/5jbx0nr2y3b0hr0gv4np4wplzigrxhjw-zstd-1.5.7-dev' '/nix/store/bmdx7cg3zq7f53pl7x86v9j9b4j59cn1-zstd-1.5.7-bin' '/nix/store/s7vmxmhkq439cjb7ag9w198p6dk7kl0w-zstd-1.5.7' '/nix/store/0rfz69vp1nl0q2hxzig20hc60sk72z62-curl-8.17.0-bin' '/nix/store/8idis3j5l13c3x74jl8xly0k4qyk9mx6-curl-8.17.0' '/nix/store/lkdgiqh4qidry0ka5ky2fj842jnf3g35-du-dust-1.2.3' '/nix/store/z1h5sg9kdhkfxycz590gjxsymv9xvn0x-eza-0.23.4' '/nix/store/027m34av4nx0246ia2qdbfygzy9dbikw-fd-10.3.0' '/nix/store/lc3zmvfh5cyzdgijm8f5sjgd0q3hl9pk-fzf-0.67.0' '/nix/store/y12yx7z4g4a3jbzh28h6yrpvcf6px5kl-gh-2.83.1' '/nix/store/4qhdhmi7pzgad0zfd7c5lsg235mbf9hv-git-2.51.2' '/nix/store/ilh909avv5bj1hhz9iv8hsrc5pqygr2c-python3.13-git-filter-repo-2.47.0' '/nix/store/3lll9y925zz9393sa59h653xik66srjb-python3-3.13.9' '/nix/store/0a3dyfq09dnkw28ap2i450wjimvdmv6s-go-1.25.4' '/nix/store/874x411xcsavf0fcgrhp2bm9df3s6si0-google-chrome-142.0.7444.175' '/nix/store/jq07r49vk5wa10a1kk2y87nwbbl62qxz-jq-1.8.1-dev' '/nix/store/qvbwz06cqra3cmlra40v0adw75j6j7wm-jq-1.8.1-bin' '/nix/store/gs6yqc24w093xsnnz3kkhls8jz7pnffy-jq-1.8.1' '/nix/store/pfkyva576bsx649x918pgysdr1rcyxzq-less-679' '/nix/store/p921cknvlpr9cwqwy0xdl2m9bqclq2y2-ncurses-6.5-dev' '/nix/store/yijhn548p2589pkybgvbhll09bqsxy0q-ncurses-6.5' '/nix/store/lcx3yp56z7zd0dw5g2mk7vranz07cska-nerdctl-1.7.7' '/nix/store/l1idqv7ff0m2kbcqnn1yr415wyga1wxf-nodejs-22.21.1-dev' '/nix/store/l85fis49agvp5q1ild1rfh4rrgmn92sr-nodejs-22.21.1' '/nix/store/8qh5h6cfwpfih87rdsnknva6jqb6sc3l-podman-5.7.0' '/nix/store/2fngznir58zqpvg2wl7iy5amlsbzhf9p-ripgrep-15.1.0' '/nix/store/lj0a1vqf1jyn90lg69bgxxkxv5s4kcx3-whereis-util-linux-2.41.2' '/nix/store/h7fgzg0gkpar781i0vj423sq8zyr24a5-unzip-6.0' '/nix/store/rwj0jbi98wrrg4c4k8a5s63cp8r7s8a9-which-2.23' '/nix/store/swrlnxx8q7l3a0pb4lzdlmgwxczmjp4f-wl-clipboard-2.2.1' '/nix/store/13d432s7zrxh43s8nrvxw2jq4sww4k3x-xdg-utils-1.2.1' '/nix/store/jk0qzin2yinxmfxzj03mq8pfbcgwiwrd-python3.13-yq-3.4.3' '/nix/store/zvi1w146j2s60jj4ss7ws5hfi8s72h9d-python3.13-argcomplete-3.6.2' '/nix/store/yv88fk5ya2c35gbady8ssmg3l92k4vki-python3.13-pyyaml-6.0.3' '/nix/store/j5bq6balpx7l4lhdj7z89z0xvb7w722k-python3.13-tomlkit-0.13.3' '/nix/store/0x0akdb42vrj5xykcch0fsckgaxvl2n4-python3.13-xmltodict-1.0.2' '/nix/store/wjpwflilg7qyx5y6pgn8s1cmavs0im4n-zed-editor-0.213.3' '/nix/store/hjlkypp9lpxwzsjycpy7nqg2mnl7qhzv-glibc-locales-2.40-66' '/nix/store/a5wfpm3h60lxplf2mymxfn90dp5xndb1-nvim' '/nix/store/v4jw5rgwqfv0v5cwqbk4ncpv672gk96m-treesitter-cli' '/nix/store/cfs9q5b2lq4vwayr0ir21fvm75ci31zf-patch-dynamic-loader' )
declare -a pkgsTargetTarget=()
declare -a postFixupHooks=('noBrokenSymlinksInAllOutputs' '_makeSymlinksRelativeInAllOutputs' '_multioutPropagateDev' )
declare -a postUnpackHooks=('_updateSourceDateEpochFromSourceRoot' )
declare -a preConfigureHooks=('_multioutConfig' )
preConfigurePhases=' updateAutotoolsGnuConfigScriptsPhase'
declare -a preFixupHooks=('_moveToShare' '_multioutDocs' '_multioutDevs' )
preferLocalBuild='1'
export preferLocalBuild
prefix='/workspace-flake/outputs/out'
declare -a propagatedBuildDepFiles=('propagated-build-build-deps' 'propagated-native-build-inputs' 'propagated-build-target-deps' )
propagatedBuildInputs=''
export propagatedBuildInputs
declare -a propagatedHostDepFiles=('propagated-host-host-deps' 'propagated-build-inputs' )
propagatedNativeBuildInputs=''
export propagatedNativeBuildInputs
declare -a propagatedTargetDepFiles=('propagated-target-target-deps' )
shell='/nix/store/rlq03x4cwf8zn73hxaxnx0zn5q9kifls-bash-5.3p3/bin/bash'
export shell
shellHook='export LOCALE_ARCHIVE=/nix/store/hjlkypp9lpxwzsjycpy7nqg2mnl7qhzv-glibc-locales-2.40-66/lib/locale/locale-archive

source /nix/store/0sl23ayhi8bxylgxvlpxsk5yqn40hjad-bash-completion-2.17.0/etc/profile.d/bash_completion.sh

if [ -z "$LANG" ]; then
  # INFO: if LANG env var unset, set it to en_US.UTF-8
  export LANG="en_US.UTF-8"
fi

# INFO: this ensures, we always have /usr/bin/env
[ ! -e /usr/bin ] && [ -e "/nix/store/imad8dvhp77h0pjbckp6wvmnyhp8dpgg-coreutils-9.8/bin" ] && ln -sf /nix/store/imad8dvhp77h0pjbckp6wvmnyhp8dpgg-coreutils-9.8/bin /usr/bin
[ ! -e /usr/share ] && [ -e "/nix/store/imad8dvhp77h0pjbckp6wvmnyhp8dpgg-coreutils-9.8/share" ] && ln -sf /nix/store/imad8dvhp77h0pjbckp6wvmnyhp8dpgg-coreutils-9.8/share /usr/share
[ ! -e /usr/libexec ] && [ -e "/nix/store/imad8dvhp77h0pjbckp6wvmnyhp8dpgg-coreutils-9.8/libexec" ] && ln -sf /nix/store/imad8dvhp77h0pjbckp6wvmnyhp8dpgg-coreutils-9.8/libexec /usr/libexec
[ ! -e /usr/lib ] && [ -e "/nix/store/imad8dvhp77h0pjbckp6wvmnyhp8dpgg-coreutils-9.8/lib" ] && ln -sf /nix/store/imad8dvhp77h0pjbckp6wvmnyhp8dpgg-coreutils-9.8/lib /usr/lib

# INFO: it seems like many tools have hardcoded value for /bin/sh, so we need to make sure that /bin/sh exists
if [ ! -e "/bin/sh" ]; then
  mkdir -p /bin
  ln -sf $(which bash) /bin/sh
fi

if [ -n "" ]; then
  export LD_LIBRARY_PATH=":$LD_LIBRARY_PATH"
fi
export BROWSER="google-chrome-stable"
export CONTAINER_HOST="unix:///run/user/1000/podman/podman.sock"
export DISPLAY=":0"
export DOCKER_HOST="/run/user/1000/podman/podman.sock"
export IS_DEMO="1"
export SSH_AUTH_SOCK="/home/nxtcoder17/.ssh/agent.sock"
export WAYLAND_DISPLAY="wayland-1"
export XDG_BACKEND="wayland"
export XDG_RUNTIME_DIR="/run/user/1000"

if [ -e shell-enter.sh ]; then
  source "shell-enter.sh"
fi

if [ -n "$NIXY_BUILD_SCRIPT" ] && [ -e "$NIXY_BUILD_SCRIPT" ]; then
  source "$NIXY_BUILD_SCRIPT"
fi

cd /home/nxtcoder17/workspace/nxtcoder17/jeera-rice/apps/nvim/.config/nvim.fat
'
export shellHook
stdenv='/nix/store/s3w5m3spa1g71hx0yb82lvk6394j3w5j-stdenv-linux'
export stdenv
strictDeps=''
export strictDeps
system='x86_64-linux'
export system
declare -a unpackCmdHooks=('_tryUnzip' '_defaultUnpack' )
_activatePkgs ()
{
 
    local hostOffset targetOffset;
    local pkg;
    for hostOffset in "${allPlatOffsets[@]}";
    do
        local pkgsVar="${pkgAccumVarVars[hostOffset + 1]}";
        for targetOffset in "${allPlatOffsets[@]}";
        do
            (( hostOffset <= targetOffset )) || continue;
            local pkgsRef="${pkgsVar}[$targetOffset - $hostOffset]";
            local pkgsSlice="${!pkgsRef}[@]";
            for pkg in ${!pkgsSlice+"${!pkgsSlice}"};
            do
                activatePackage "$pkg" "$hostOffset" "$targetOffset";
            done;
        done;
    done
}
_addRpathPrefix ()
{
 
    if [ "${NIX_NO_SELF_RPATH:-0}" != 1 ]; then
        export NIX_LDFLAGS="-rpath $1/lib ${NIX_LDFLAGS-}";
    fi
}
_addToEnv ()
{
 
    local depHostOffset depTargetOffset;
    local pkg;
    for depHostOffset in "${allPlatOffsets[@]}";
    do
        local hookVar="${pkgHookVarVars[depHostOffset + 1]}";
        local pkgsVar="${pkgAccumVarVars[depHostOffset + 1]}";
        for depTargetOffset in "${allPlatOffsets[@]}";
        do
            (( depHostOffset <= depTargetOffset )) || continue;
            local hookRef="${hookVar}[$depTargetOffset - $depHostOffset]";
            if [[ -z "${strictDeps-}" ]]; then
                local visitedPkgs="";
                for pkg in "${pkgsBuildBuild[@]}" "${pkgsBuildHost[@]}" "${pkgsBuildTarget[@]}" "${pkgsHostHost[@]}" "${pkgsHostTarget[@]}" "${pkgsTargetTarget[@]}";
                do
                    if [[ "$visitedPkgs" = *"$pkg"* ]]; then
                        continue;
                    fi;
                    runHook "${!hookRef}" "$pkg";
                    visitedPkgs+=" $pkg";
                done;
            else
                local pkgsRef="${pkgsVar}[$depTargetOffset - $depHostOffset]";
                local pkgsSlice="${!pkgsRef}[@]";
                for pkg in ${!pkgsSlice+"${!pkgsSlice}"};
                do
                    runHook "${!hookRef}" "$pkg";
                done;
            fi;
        done;
    done
}
_allFlags ()
{
 
    export system pname name version;
    while IFS='' read -r varName; do
        nixTalkativeLog "@${varName}@ -> ${!varName}";
        args+=("--subst-var" "$varName");
    done < <(awk 'BEGIN { for (v in ENVIRON) if (v ~ /^[a-z][a-zA-Z0-9_]*$/) print v }')
}
_assignFirst ()
{
 
    local varName="$1";
    local _var;
    local REMOVE=REMOVE;
    shift;
    for _var in "$@";
    do
        if [ -n "${!_var-}" ]; then
            eval "${varName}"="${_var}";
            return;
        fi;
    done;
    echo;
    echo "error: _assignFirst: could not find a non-empty variable whose name to assign to ${varName}.";
    echo "       The following variables were all unset or empty:";
    echo "           $*";
    if [ -z "${out:-}" ]; then
        echo '       If you do not want an "out" output in your derivation, make sure to define';
        echo '       the other specific required outputs. This can be achieved by picking one';
        echo "       of the above as an output.";
        echo '       You do not have to remove "out" if you want to have a different default';
        echo '       output, because the first output is taken as a default.';
        echo;
    fi;
    return 1
}
_callImplicitHook ()
{
 
    local def="$1";
    local hookName="$2";
    if declare -F "$hookName" > /dev/null; then
        nixTalkativeLog "calling implicit '$hookName' function hook";
        "$hookName";
    else
        if type -p "$hookName" > /dev/null; then
            nixTalkativeLog "sourcing implicit '$hookName' script hook";
            source "$hookName";
        else
            if [ -n "${!hookName:-}" ]; then
                nixTalkativeLog "evaling implicit '$hookName' string hook";
                eval "${!hookName}";
            else
                return "$def";
            fi;
        fi;
    fi
}
_defaultUnpack ()
{
 
    local fn="$1";
    local destination;
    if [ -d "$fn" ]; then
        destination="$(stripHash "$fn")";
        if [ -e "$destination" ]; then
            echo "Cannot copy $fn to $destination: destination already exists!";
            echo "Did you specify two \"srcs\" with the same \"name\"?";
            return 1;
        fi;
        cp -r --preserve=timestamps --reflink=auto -- "$fn" "$destination";
    else
        case "$fn" in 
            *.tar.xz | *.tar.lzma | *.txz)
                ( XZ_OPT="--threads=$NIX_BUILD_CORES" xz -d < "$fn";
                true ) | tar xf - --mode=+w --warning=no-timestamp
            ;;
            *.tar | *.tar.* | *.tgz | *.tbz2 | *.tbz)
                tar xf "$fn" --mode=+w --warning=no-timestamp
            ;;
            *)
                return 1
            ;;
        esac;
    fi
}
_doStrip ()
{
 
    local -ra flags=(dontStripHost dontStripTarget);
    local -ra debugDirs=(stripDebugList stripDebugListTarget);
    local -ra allDirs=(stripAllList stripAllListTarget);
    local -ra stripCmds=(STRIP STRIP_FOR_TARGET);
    local -ra ranlibCmds=(RANLIB RANLIB_FOR_TARGET);
    stripDebugList=${stripDebugList[*]:-lib lib32 lib64 libexec bin sbin Applications Library/Frameworks};
    stripDebugListTarget=${stripDebugListTarget[*]:-};
    stripAllList=${stripAllList[*]:-};
    stripAllListTarget=${stripAllListTarget[*]:-};
    local i;
    for i in ${!stripCmds[@]};
    do
        local -n flag="${flags[$i]}";
        local -n debugDirList="${debugDirs[$i]}";
        local -n allDirList="${allDirs[$i]}";
        local -n stripCmd="${stripCmds[$i]}";
        local -n ranlibCmd="${ranlibCmds[$i]}";
        if [[ -n "${dontStrip-}" || -n "${flag-}" ]] || ! type -f "${stripCmd-}" 2> /dev/null 1>&2; then
            continue;
        fi;
        stripDirs "$stripCmd" "$ranlibCmd" "$debugDirList" "${stripDebugFlags[*]:--S -p}";
        stripDirs "$stripCmd" "$ranlibCmd" "$allDirList" "${stripAllFlags[*]:--s -p}";
    done
}
_eval ()
{
 
    if declare -F "$1" > /dev/null 2>&1; then
        "$@";
    else
        eval "$1";
    fi
}
_logHook ()
{
 
    if [[ -z ${NIX_LOG_FD-} ]]; then
        return;
    fi;
    local hookKind="$1";
    local hookExpr="$2";
    shift 2;
    if declare -F "$hookExpr" > /dev/null 2>&1; then
        nixTalkativeLog "calling '$hookKind' function hook '$hookExpr'" "$@";
    else
        if type -p "$hookExpr" > /dev/null; then
            nixTalkativeLog "sourcing '$hookKind' script hook '$hookExpr'";
        else
            if [[ "$hookExpr" != "_callImplicitHook"* ]]; then
                local exprToOutput;
                if [[ ${NIX_DEBUG:-0} -ge 5 ]]; then
                    exprToOutput="$hookExpr";
                else
                    local hookExprLine;
                    while IFS= read -r hookExprLine; do
                        hookExprLine="${hookExprLine#"${hookExprLine%%[![:space:]]*}"}";
                        if [[ -n "$hookExprLine" ]]; then
                            exprToOutput+="$hookExprLine\\n ";
                        fi;
                    done <<< "$hookExpr";
                    exprToOutput="${exprToOutput%%\\n }";
                fi;
                nixTalkativeLog "evaling '$hookKind' string hook '$exprToOutput'";
            fi;
        fi;
    fi
}
_makeSymlinksRelative ()
{
 
    local symlinkTarget;
    if [ "${dontRewriteSymlinks-}" ] || [ ! -e "$prefix" ]; then
        return;
    fi;
    while IFS= read -r -d '' f; do
        symlinkTarget=$(readlink "$f");
        if [[ "$symlinkTarget"/ != "$prefix"/* ]]; then
            continue;
        fi;
        if [ ! -e "$symlinkTarget" ]; then
            echo "the symlink $f is broken, it points to $symlinkTarget (which is missing)";
        fi;
        echo "rewriting symlink $f to be relative to $prefix";
        ln -snrf "$symlinkTarget" "$f";
    done < <(find $prefix -type l -print0)
}
_makeSymlinksRelativeInAllOutputs ()
{
 
    local output;
    for output in $(getAllOutputNames);
    do
        prefix="${!output}" _makeSymlinksRelative;
    done
}
_moveLib64 ()
{
 
    if [ "${dontMoveLib64-}" = 1 ]; then
        return;
    fi;
    if [ ! -e "$prefix/lib64" -o -L "$prefix/lib64" ]; then
        return;
    fi;
    echo "moving $prefix/lib64/* to $prefix/lib";
    mkdir -p $prefix/lib;
    shopt -s dotglob;
    for i in $prefix/lib64/*;
    do
        mv --no-clobber "$i" $prefix/lib;
    done;
    shopt -u dotglob;
    rmdir $prefix/lib64;
    ln -s lib $prefix/lib64
}
_moveSbin ()
{
 
    if [ "${dontMoveSbin-}" = 1 ]; then
        return;
    fi;
    if [ ! -e "$prefix/sbin" -o -L "$prefix/sbin" ]; then
        return;
    fi;
    echo "moving $prefix/sbin/* to $prefix/bin";
    mkdir -p $prefix/bin;
    shopt -s dotglob;
    for i in $prefix/sbin/*;
    do
        mv "$i" $prefix/bin;
    done;
    shopt -u dotglob;
    rmdir $prefix/sbin;
    ln -s bin $prefix/sbin
}
_moveSystemdUserUnits ()
{
 
    if [ "${dontMoveSystemdUserUnits:-0}" = 1 ]; then
        return;
    fi;
    if [ ! -e "${prefix:?}/lib/systemd/user" ]; then
        return;
    fi;
    local source="$prefix/lib/systemd/user";
    local target="$prefix/share/systemd/user";
    echo "moving $source/* to $target";
    mkdir -p "$target";
    ( shopt -s dotglob;
    for i in "$source"/*;
    do
        mv "$i" "$target";
    done );
    rmdir "$source";
    ln -s "$target" "$source"
}
_moveToShare ()
{
 
    if [ -n "$__structuredAttrs" ]; then
        if [ -z "${forceShare-}" ]; then
            forceShare=(man doc info);
        fi;
    else
        forceShare=(${forceShare:-man doc info});
    fi;
    if [[ -z "$out" ]]; then
        return;
    fi;
    for d in "${forceShare[@]}";
    do
        if [ -d "$out/$d" ]; then
            if [ -d "$out/share/$d" ]; then
                echo "both $d/ and share/$d/ exist!";
            else
                echo "moving $out/$d to $out/share/$d";
                mkdir -p $out/share;
                mv $out/$d $out/share/;
            fi;
        fi;
    done
}
_multioutConfig ()
{
 
    if [ "$(getAllOutputNames)" = "out" ] || [ -z "${setOutputFlags-1}" ]; then
        return;
    fi;
    if [ -z "${shareDocName:-}" ]; then
        local confScript="${configureScript:-}";
        if [ -z "$confScript" ] && [ -x ./configure ]; then
            confScript=./configure;
        fi;
        if [ -f "$confScript" ]; then
            local shareDocName="$(sed -n "s/^PACKAGE_TARNAME='\(.*\)'$/\1/p" < "$confScript")";
        fi;
        if [ -z "$shareDocName" ] || echo "$shareDocName" | grep -q '[^a-zA-Z0-9_-]'; then
            shareDocName="$(echo "$name" | sed 's/-[^a-zA-Z].*//')";
        fi;
    fi;
    prependToVar configureFlags --bindir="${!outputBin}"/bin --sbindir="${!outputBin}"/sbin --includedir="${!outputInclude}"/include --mandir="${!outputMan}"/share/man --infodir="${!outputInfo}"/share/info --docdir="${!outputDoc}"/share/doc/"${shareDocName}" --libdir="${!outputLib}"/lib --libexecdir="${!outputLib}"/libexec --localedir="${!outputLib}"/share/locale;
    prependToVar installFlags pkgconfigdir="${!outputDev}"/lib/pkgconfig m4datadir="${!outputDev}"/share/aclocal aclocaldir="${!outputDev}"/share/aclocal
}
_multioutDevs ()
{
 
    if [ "$(getAllOutputNames)" = "out" ] || [ -z "${moveToDev-1}" ]; then
        return;
    fi;
    moveToOutput include "${!outputInclude}";
    moveToOutput lib/pkgconfig "${!outputDev}";
    moveToOutput share/pkgconfig "${!outputDev}";
    moveToOutput lib/cmake "${!outputDev}";
    moveToOutput share/aclocal "${!outputDev}";
    for f in "${!outputDev}"/{lib,share}/pkgconfig/*.pc;
    do
        echo "Patching '$f' includedir to output ${!outputInclude}";
        sed -i "/^includedir=/s,=\${prefix},=${!outputInclude}," "$f";
    done
}
_multioutDocs ()
{
 
    local REMOVE=REMOVE;
    moveToOutput share/info "${!outputInfo}";
    moveToOutput share/doc "${!outputDoc}";
    moveToOutput share/gtk-doc "${!outputDevdoc}";
    moveToOutput share/devhelp/books "${!outputDevdoc}";
    moveToOutput share/man "${!outputMan}";
    moveToOutput share/man/man3 "${!outputDevman}"
}
_multioutPropagateDev ()
{
 
    if [ "$(getAllOutputNames)" = "out" ]; then
        return;
    fi;
    local outputFirst;
    for outputFirst in $(getAllOutputNames);
    do
        break;
    done;
    local propagaterOutput="$outputDev";
    if [ -z "$propagaterOutput" ]; then
        propagaterOutput="$outputFirst";
    fi;
    if [ -z "${propagatedBuildOutputs+1}" ]; then
        local po_dirty="$outputBin $outputInclude $outputLib";
        set +o pipefail;
        propagatedBuildOutputs=`echo "$po_dirty"             | tr -s ' ' '\n' | grep -v -F "$propagaterOutput"             | sort -u | tr '\n' ' ' `;
        set -o pipefail;
    fi;
    if [ -z "$propagatedBuildOutputs" ]; then
        return;
    fi;
    mkdir -p "${!propagaterOutput}"/nix-support;
    for output in $propagatedBuildOutputs;
    do
        echo -n " ${!output}" >> "${!propagaterOutput}"/nix-support/propagated-build-inputs;
    done
}
_nixLogWithLevel ()
{
 
    [[ -z ${NIX_LOG_FD-} || ${NIX_DEBUG:-0} -lt ${1:?} ]] && return 0;
    local logLevel;
    case "${1:?}" in 
        0)
            logLevel=ERROR
        ;;
        1)
            logLevel=WARN
        ;;
        2)
            logLevel=NOTICE
        ;;
        3)
            logLevel=INFO
        ;;
        4)
            logLevel=TALKATIVE
        ;;
        5)
            logLevel=CHATTY
        ;;
        6)
            logLevel=DEBUG
        ;;
        7)
            logLevel=VOMIT
        ;;
        *)
            echo "_nixLogWithLevel: called with invalid log level: ${1:?}" >&"$NIX_LOG_FD";
            return 1
        ;;
    esac;
    local callerName="${FUNCNAME[2]}";
    if [[ $callerName == "_callImplicitHook" ]]; then
        callerName="${hookName:?}";
    fi;
    printf "%s: %s: %s\n" "$logLevel" "$callerName" "${2:?}" >&"$NIX_LOG_FD"
}
_overrideFirst ()
{
 
    if [ -z "${!1-}" ]; then
        _assignFirst "$@";
    fi
}
_pruneLibtoolFiles ()
{
 
    if [ "${dontPruneLibtoolFiles-}" ] || [ ! -e "$prefix" ]; then
        return;
    fi;
    find "$prefix" -type f -name '*.la' -exec grep -q '^# Generated by .*libtool' {} \; -exec grep -q "^old_library=''" {} \; -exec sed -i {} -e "/^dependency_libs='[^']/ c dependency_libs='' #pruned" \;
}
_tryUnzip ()
{
 
    if ! [[ "$curSrc" =~ \.zip$ ]]; then
        return 1;
    fi;
    LANG=en_US.UTF-8 unzip -qq "$curSrc"
}
_updateSourceDateEpochFromSourceRoot ()
{
 
    if [ -n "$sourceRoot" ]; then
        updateSourceDateEpoch "$sourceRoot";
    fi
}
activatePackage ()
{
 
    local pkg="$1";
    local -r hostOffset="$2";
    local -r targetOffset="$3";
    (( hostOffset <= targetOffset )) || exit 1;
    if [ -f "$pkg" ]; then
        nixTalkativeLog "sourcing setup hook '$pkg'";
        source "$pkg";
    fi;
    if [[ -z "${strictDeps-}" || "$hostOffset" -le -1 ]]; then
        addToSearchPath _PATH "$pkg/bin";
    fi;
    if (( hostOffset <= -1 )); then
        addToSearchPath _XDG_DATA_DIRS "$pkg/share";
    fi;
    if [[ "$hostOffset" -eq 0 && -d "$pkg/bin" ]]; then
        addToSearchPath _HOST_PATH "$pkg/bin";
    fi;
    if [[ -f "$pkg/nix-support/setup-hook" ]]; then
        nixTalkativeLog "sourcing setup hook '$pkg/nix-support/setup-hook'";
        source "$pkg/nix-support/setup-hook";
    fi
}
addEnvHooks ()
{
 
    local depHostOffset="$1";
    shift;
    local pkgHookVarsSlice="${pkgHookVarVars[$depHostOffset + 1]}[@]";
    local pkgHookVar;
    for pkgHookVar in "${!pkgHookVarsSlice}";
    do
        eval "${pkgHookVar}s"'+=("$@")';
    done
}
addNodePath ()
{
 
    addToSearchPath NODE_PATH "$1/lib/node_modules"
}
addPythonPath ()
{
 
    addToSearchPathWithCustomDelimiter : PYTHONPATH $1/lib/python3.13/site-packages
}
addToSearchPath ()
{
 
    addToSearchPathWithCustomDelimiter ":" "$@"
}
addToSearchPathWithCustomDelimiter ()
{
 
    local delimiter="$1";
    local varName="$2";
    local dir="$3";
    if [[ -d "$dir" && "${!varName:+${delimiter}${!varName}${delimiter}}" != *"${delimiter}${dir}${delimiter}"* ]]; then
        export "${varName}=${!varName:+${!varName}${delimiter}}${dir}";
    fi
}
appendToVar ()
{
 
    local -n nameref="$1";
    local useArray type;
    if [ -n "$__structuredAttrs" ]; then
        useArray=true;
    else
        useArray=false;
    fi;
    if type=$(declare -p "$1" 2> /dev/null); then
        case "${type#* }" in 
            -A*)
                echo "appendToVar(): ERROR: trying to use appendToVar on an associative array, use variable+=([\"X\"]=\"Y\") instead." 1>&2;
                return 1
            ;;
            -a*)
                useArray=true
            ;;
            *)
                useArray=false
            ;;
        esac;
    fi;
    shift;
    if $useArray; then
        nameref=(${nameref+"${nameref[@]}"} "$@");
    else
        nameref="${nameref-} $*";
    fi
}
auditTmpdir ()
{
 
    local dir="$1";
    [ -e "$dir" ] || return 0;
    echo "checking for references to $TMPDIR/ in $dir...";
    local tmpdir elf_fifo script_fifo;
    tmpdir="$(mktemp -d)";
    elf_fifo="$tmpdir/elf";
    script_fifo="$tmpdir/script";
    mkfifo "$elf_fifo" "$script_fifo";
    ( find "$dir" -type f -not -path '*/.build-id/*' -print0 | while IFS= read -r -d '' file; do
        if isELF "$file"; then
            printf '%s\0' "$file" 1>&3;
        else
            if isScript "$file"; then
                filename=${file##*/};
                dir=${file%/*};
                if [ -e "$dir/.$filename-wrapped" ]; then
                    printf '%s\0' "$file" 1>&4;
                fi;
            fi;
        fi;
    done;
    exec 3>&- 4>&- ) 3> "$elf_fifo" 4> "$script_fifo" & ( xargs -0 -r -P "$NIX_BUILD_CORES" -n 1 sh -c '
            if { printf :; patchelf --print-rpath "$1"; } | grep -q -F ":$TMPDIR/"; then
                echo "RPATH of binary $1 contains a forbidden reference to $TMPDIR/"
                exit 1
            fi
        ' _ < "$elf_fifo" ) & local pid_elf=$!;
    local pid_script;
    ( xargs -0 -r -P "$NIX_BUILD_CORES" -n 1 sh -c '
            if grep -q -F "$TMPDIR/" "$1"; then
                echo "wrapper script $1 contains a forbidden reference to $TMPDIR/"
                exit 1
            fi
        ' _ < "$script_fifo" ) & local pid_script=$!;
    wait "$pid_elf" || { 
        echo "Some binaries contain forbidden references to $TMPDIR/. Check the error above!";
        exit 1
    };
    wait "$pid_script" || { 
        echo "Some scripts contain forbidden references to $TMPDIR/. Check the error above!";
        exit 1
    };
    rm -r "$tmpdir"
}
bintoolsWrapper_addLDVars ()
{
 
    local role_post;
    getHostRoleEnvHook;
    if [[ -d "$1/lib64" && ! -L "$1/lib64" ]]; then
        export NIX_LDFLAGS${role_post}+=" -L$1/lib64";
    fi;
    if [[ -d "$1/lib" ]]; then
        local -a glob=($1/lib/lib*);
        if [ "${#glob[*]}" -gt 0 ]; then
            export NIX_LDFLAGS${role_post}+=" -L$1/lib";
        fi;
    fi
}
buildPhase ()
{
 
    runHook preBuild;
    if [[ -z "${makeFlags-}" && -z "${makefile:-}" && ! ( -e Makefile || -e makefile || -e GNUmakefile ) ]]; then
        echo "no Makefile or custom buildPhase, doing nothing";
    else
        foundMakefile=1;
        local flagsArray=(${enableParallelBuilding:+-j${NIX_BUILD_CORES}} SHELL="$SHELL");
        concatTo flagsArray makeFlags makeFlagsArray buildFlags buildFlagsArray;
        echoCmd 'build flags' "${flagsArray[@]}";
        make ${makefile:+-f $makefile} "${flagsArray[@]}";
        unset flagsArray;
    fi;
    runHook postBuild
}
ccWrapper_addCVars ()
{
 
    local role_post;
    getHostRoleEnvHook;
    local found=;
    if [ -d "$1/include" ]; then
        export NIX_CFLAGS_COMPILE${role_post}+=" -isystem $1/include";
        found=1;
    fi;
    if [ -d "$1/Library/Frameworks" ]; then
        export NIX_CFLAGS_COMPILE${role_post}+=" -iframework $1/Library/Frameworks";
        found=1;
    fi;
    if [[ -n "" && -n ${NIX_STORE:-} && -n $found ]]; then
        local scrubbed="$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-${1#"$NIX_STORE"/*-}";
        export NIX_CFLAGS_COMPILE${role_post}+=" -fmacro-prefix-map=$1=$scrubbed";
    fi
}
checkPhase ()
{
 
    runHook preCheck;
    if [[ -z "${foundMakefile:-}" ]]; then
        echo "no Makefile or custom checkPhase, doing nothing";
        runHook postCheck;
        return;
    fi;
    if [[ -z "${checkTarget:-}" ]]; then
        if make -n ${makefile:+-f $makefile} check > /dev/null 2>&1; then
            checkTarget="check";
        else
            if make -n ${makefile:+-f $makefile} test > /dev/null 2>&1; then
                checkTarget="test";
            fi;
        fi;
    fi;
    if [[ -z "${checkTarget:-}" ]]; then
        echo "no check/test target in ${makefile:-Makefile}, doing nothing";
    else
        local flagsArray=(${enableParallelChecking:+-j${NIX_BUILD_CORES}} SHELL="$SHELL");
        concatTo flagsArray makeFlags makeFlagsArray checkFlags=VERBOSE=y checkFlagsArray checkTarget;
        echoCmd 'check flags' "${flagsArray[@]}";
        make ${makefile:+-f $makefile} "${flagsArray[@]}";
        unset flagsArray;
    fi;
    runHook postCheck
}
compressManPages ()
{
 
    local dir="$1";
    if [ -L "$dir"/share ] || [ -L "$dir"/share/man ] || [ ! -d "$dir/share/man" ]; then
        return;
    fi;
    echo "gzipping man pages under $dir/share/man/";
    find "$dir"/share/man/ -type f -a '!' -regex '.*\.\(bz2\|gz\|xz\)$' -print0 | xargs -0 -n1 -P "$NIX_BUILD_CORES" gzip -n -f;
    find "$dir"/share/man/ -type l -a '!' -regex '.*\.\(bz2\|gz\|xz\)$' -print0 | sort -z | while IFS= read -r -d '' f; do
        local target;
        target="$(readlink -f "$f")";
        if [ -f "$target".gz ]; then
            ln -sf "$target".gz "$f".gz && rm "$f";
        fi;
    done
}
concatStringsSep ()
{
 
    local sep="$1";
    local name="$2";
    local type oldifs;
    if type=$(declare -p "$name" 2> /dev/null); then
        local -n nameref="$name";
        case "${type#* }" in 
            -A*)
                echo "concatStringsSep(): ERROR: trying to use concatStringsSep on an associative array." 1>&2;
                return 1
            ;;
            -a*)
                local IFS="$(printf '\036')"
            ;;
            *)
                local IFS=" "
            ;;
        esac;
        local ifs_separated="${nameref[*]}";
        echo -n "${ifs_separated//"$IFS"/"$sep"}";
    fi
}
concatTo ()
{
 
    local -;
    set -o noglob;
    local -n targetref="$1";
    shift;
    local arg default name type;
    for arg in "$@";
    do
        IFS="=" read -r name default <<< "$arg";
        local -n nameref="$name";
        if [[ -z "${nameref[*]}" && -n "$default" ]]; then
            targetref+=("$default");
        else
            if type=$(declare -p "$name" 2> /dev/null); then
                case "${type#* }" in 
                    -A*)
                        echo "concatTo(): ERROR: trying to use concatTo on an associative array." 1>&2;
                        return 1
                    ;;
                    -a*)
                        targetref+=("${nameref[@]}")
                    ;;
                    *)
                        if [[ "$name" = *"Array" ]]; then
                            nixErrorLog "concatTo(): $name is not declared as array, treating as a singleton. This will become an error in future";
                            targetref+=(${nameref+"${nameref[@]}"});
                        else
                            targetref+=(${nameref-});
                        fi
                    ;;
                esac;
            fi;
        fi;
    done
}
configurePhase ()
{
 
    runHook preConfigure;
    : "${configureScript=}";
    if [[ -z "$configureScript" && -x ./configure ]]; then
        configureScript=./configure;
    fi;
    if [ -z "${dontFixLibtool:-}" ]; then
        export lt_cv_deplibs_check_method="${lt_cv_deplibs_check_method-pass_all}";
        local i;
        find . -iname "ltmain.sh" -print0 | while IFS='' read -r -d '' i; do
            echo "fixing libtool script $i";
            fixLibtool "$i";
        done;
        CONFIGURE_MTIME_REFERENCE=$(mktemp configure.mtime.reference.XXXXXX);
        find . -executable -type f -name configure -exec grep -l 'GNU Libtool is free software; you can redistribute it and/or modify' {} \; -exec touch -r {} "$CONFIGURE_MTIME_REFERENCE" \; -exec sed -i s_/usr/bin/file_file_g {} \; -exec touch -r "$CONFIGURE_MTIME_REFERENCE" {} \;;
        rm -f "$CONFIGURE_MTIME_REFERENCE";
    fi;
    if [[ -z "${dontAddPrefix:-}" && -n "$prefix" ]]; then
        prependToVar configureFlags "${prefixKey:---prefix=}$prefix";
    fi;
    if [[ -f "$configureScript" ]]; then
        if [ -z "${dontAddDisableDepTrack:-}" ]; then
            if grep -q dependency-tracking "$configureScript"; then
                prependToVar configureFlags --disable-dependency-tracking;
            fi;
        fi;
        if [ -z "${dontDisableStatic:-}" ]; then
            if grep -q enable-static "$configureScript"; then
                prependToVar configureFlags --disable-static;
            fi;
        fi;
        if [ -z "${dontPatchShebangsInConfigure:-}" ]; then
            patchShebangs --build "$configureScript";
        fi;
    fi;
    if [ -n "$configureScript" ]; then
        local -a flagsArray;
        concatTo flagsArray configureFlags configureFlagsArray;
        echoCmd 'configure flags' "${flagsArray[@]}";
        $configureScript "${flagsArray[@]}";
        unset flagsArray;
    else
        echo "no configure script, doing nothing";
    fi;
    runHook postConfigure
}
consumeEntire ()
{
 
    if IFS='' read -r -d '' "$1"; then
        echo "consumeEntire(): ERROR: Input null bytes, won't process" 1>&2;
        return 1;
    fi
}
distPhase ()
{
 
    runHook preDist;
    local flagsArray=();
    concatTo flagsArray distFlags distFlagsArray distTarget=dist;
    echo 'dist flags: %q' "${flagsArray[@]}";
    make ${makefile:+-f $makefile} "${flagsArray[@]}";
    if [ "${dontCopyDist:-0}" != 1 ]; then
        mkdir -p "$out/tarballs";
        cp -pvd ${tarballs[*]:-*.tar.gz} "$out/tarballs";
    fi;
    runHook postDist
}
dumpVars ()
{
 
    if [[ "${noDumpEnvVars:-0}" != 1 && -d "$NIX_BUILD_TOP" ]]; then
        local old_umask;
        old_umask=$(umask);
        umask 0077;
        export 2> /dev/null > "$NIX_BUILD_TOP/env-vars";
        umask "$old_umask";
    fi
}
echoCmd ()
{
 
    printf "%s:" "$1";
    shift;
    printf ' %q' "$@";
    echo
}
exitHandler ()
{
 
    exitCode="$?";
    set +e;
    if [ -n "${showBuildStats:-}" ]; then
        read -r -d '' -a buildTimes < <(times);
        echo "build times:";
        echo "user time for the shell             ${buildTimes[0]}";
        echo "system time for the shell           ${buildTimes[1]}";
        echo "user time for all child processes   ${buildTimes[2]}";
        echo "system time for all child processes ${buildTimes[3]}";
    fi;
    if (( "$exitCode" != 0 )); then
        runHook failureHook;
        if [ -n "${succeedOnFailure:-}" ]; then
            echo "build failed with exit code $exitCode (ignored)";
            mkdir -p "$out/nix-support";
            printf "%s" "$exitCode" > "$out/nix-support/failed";
            exit 0;
        fi;
    else
        runHook exitHook;
    fi;
    return "$exitCode"
}
findInputs ()
{
 
    local -r pkg="$1";
    local -r hostOffset="$2";
    local -r targetOffset="$3";
    (( hostOffset <= targetOffset )) || exit 1;
    local varVar="${pkgAccumVarVars[hostOffset + 1]}";
    local varRef="$varVar[$((targetOffset - hostOffset))]";
    local var="${!varRef}";
    unset -v varVar varRef;
    local varSlice="$var[*]";
    case " ${!varSlice-} " in 
        *" $pkg "*)
            return 0
        ;;
    esac;
    unset -v varSlice;
    eval "$var"'+=("$pkg")';
    if ! [ -e "$pkg" ]; then
        echo "build input $pkg does not exist" 1>&2;
        exit 1;
    fi;
    function mapOffset () 
    { 
        local -r inputOffset="$1";
        local -n outputOffset="$2";
        if (( inputOffset <= 0 )); then
            outputOffset=$((inputOffset + hostOffset));
        else
            outputOffset=$((inputOffset - 1 + targetOffset));
        fi
    };
    local relHostOffset;
    for relHostOffset in "${allPlatOffsets[@]}";
    do
        local files="${propagatedDepFilesVars[relHostOffset + 1]}";
        local hostOffsetNext;
        mapOffset "$relHostOffset" hostOffsetNext;
        (( -1 <= hostOffsetNext && hostOffsetNext <= 1 )) || continue;
        local relTargetOffset;
        for relTargetOffset in "${allPlatOffsets[@]}";
        do
            (( "$relHostOffset" <= "$relTargetOffset" )) || continue;
            local fileRef="${files}[$relTargetOffset - $relHostOffset]";
            local file="${!fileRef}";
            unset -v fileRef;
            local targetOffsetNext;
            mapOffset "$relTargetOffset" targetOffsetNext;
            (( -1 <= hostOffsetNext && hostOffsetNext <= 1 )) || continue;
            [[ -f "$pkg/nix-support/$file" ]] || continue;
            local pkgNext;
            read -r -d '' pkgNext < "$pkg/nix-support/$file" || true;
            for pkgNext in $pkgNext;
            do
                findInputs "$pkgNext" "$hostOffsetNext" "$targetOffsetNext";
            done;
        done;
    done
}
fixLibtool ()
{
 
    local search_path;
    for flag in $NIX_LDFLAGS;
    do
        case $flag in 
            -L*)
                search_path+=" ${flag#-L}"
            ;;
        esac;
    done;
    sed -i "$1" -e "s^eval \(sys_lib_search_path=\).*^\1'${search_path:-}'^" -e 's^eval sys_lib_.+search_path=.*^^'
}
fixupPhase ()
{
 
    local output;
    for output in $(getAllOutputNames);
    do
        if [ -e "${!output}" ]; then
            chmod -R u+w,u-s,g-s "${!output}";
        fi;
    done;
    runHook preFixup;
    local output;
    for output in $(getAllOutputNames);
    do
        prefix="${!output}" runHook fixupOutput;
    done;
    recordPropagatedDependencies;
    if [ -n "${setupHook:-}" ]; then
        mkdir -p "${!outputDev}/nix-support";
        substituteAll "$setupHook" "${!outputDev}/nix-support/setup-hook";
    fi;
    if [ -n "${setupHooks:-}" ]; then
        mkdir -p "${!outputDev}/nix-support";
        local hook;
        for hook in ${setupHooks[@]};
        do
            local content;
            consumeEntire content < "$hook";
            substituteAllStream content "file '$hook'" >> "${!outputDev}/nix-support/setup-hook";
            unset -v content;
        done;
        unset -v hook;
    fi;
    if [ -n "${propagatedUserEnvPkgs[*]:-}" ]; then
        mkdir -p "${!outputBin}/nix-support";
        printWords "${propagatedUserEnvPkgs[@]}" > "${!outputBin}/nix-support/propagated-user-env-packages";
    fi;
    runHook postFixup
}
genericBuild ()
{
 
    export GZIP_NO_TIMESTAMPS=1;
    if [ -f "${buildCommandPath:-}" ]; then
        source "$buildCommandPath";
        return;
    fi;
    if [ -n "${buildCommand:-}" ]; then
        eval "$buildCommand";
        return;
    fi;
    if [ -z "${phases[*]:-}" ]; then
        phases="${prePhases[*]:-} unpackPhase patchPhase ${preConfigurePhases[*]:-}             configurePhase ${preBuildPhases[*]:-} buildPhase checkPhase             ${preInstallPhases[*]:-} installPhase ${preFixupPhases[*]:-} fixupPhase installCheckPhase             ${preDistPhases[*]:-} distPhase ${postPhases[*]:-}";
    fi;
    for curPhase in ${phases[*]};
    do
        runPhase "$curPhase";
    done
}
getAllOutputNames ()
{
 
    if [ -n "$__structuredAttrs" ]; then
        echo "${!outputs[*]}";
    else
        echo "$outputs";
    fi
}
getHostRole ()
{
 
    getRole "$hostOffset"
}
getHostRoleEnvHook ()
{
 
    getRole "$depHostOffset"
}
getRole ()
{
 
    case $1 in 
        -1)
            role_post='_FOR_BUILD'
        ;;
        0)
            role_post=''
        ;;
        1)
            role_post='_FOR_TARGET'
        ;;
        *)
            echo "binutils-wrapper-2.44: used as improper sort of dependency" 1>&2;
            return 1
        ;;
    esac
}
getTargetRole ()
{
 
    getRole "$targetOffset"
}
getTargetRoleEnvHook ()
{
 
    getRole "$depTargetOffset"
}
getTargetRoleWrapper ()
{
 
    case $targetOffset in 
        -1)
            export NIX_BINTOOLS_WRAPPER_TARGET_BUILD_x86_64_unknown_linux_gnu=1
        ;;
        0)
            export NIX_BINTOOLS_WRAPPER_TARGET_HOST_x86_64_unknown_linux_gnu=1
        ;;
        1)
            export NIX_BINTOOLS_WRAPPER_TARGET_TARGET_x86_64_unknown_linux_gnu=1
        ;;
        *)
            echo "binutils-wrapper-2.44: used as improper sort of dependency" 1>&2;
            return 1
        ;;
    esac
}
installCheckPhase ()
{
 
    runHook preInstallCheck;
    if [[ -z "${foundMakefile:-}" ]]; then
        echo "no Makefile or custom installCheckPhase, doing nothing";
    else
        if [[ -z "${installCheckTarget:-}" ]] && ! make -n ${makefile:+-f $makefile} "${installCheckTarget:-installcheck}" > /dev/null 2>&1; then
            echo "no installcheck target in ${makefile:-Makefile}, doing nothing";
        else
            local flagsArray=(${enableParallelChecking:+-j${NIX_BUILD_CORES}} SHELL="$SHELL");
            concatTo flagsArray makeFlags makeFlagsArray installCheckFlags installCheckFlagsArray installCheckTarget=installcheck;
            echoCmd 'installcheck flags' "${flagsArray[@]}";
            make ${makefile:+-f $makefile} "${flagsArray[@]}";
            unset flagsArray;
        fi;
    fi;
    runHook postInstallCheck
}
installPhase ()
{
 
    runHook preInstall;
    if [[ -z "${makeFlags-}" && -z "${makefile:-}" && ! ( -e Makefile || -e makefile || -e GNUmakefile ) ]]; then
        echo "no Makefile or custom installPhase, doing nothing";
        runHook postInstall;
        return;
    else
        foundMakefile=1;
    fi;
    if [ -n "$prefix" ]; then
        mkdir -p "$prefix";
    fi;
    local flagsArray=(${enableParallelInstalling:+-j${NIX_BUILD_CORES}} SHELL="$SHELL");
    concatTo flagsArray makeFlags makeFlagsArray installFlags installFlagsArray installTargets=install;
    echoCmd 'install flags' "${flagsArray[@]}";
    make ${makefile:+-f $makefile} "${flagsArray[@]}";
    unset flagsArray;
    runHook postInstall
}
isELF ()
{
 
    local fn="$1";
    local fd;
    local magic;
    exec {fd}< "$fn";
    LANG=C read -r -n 4 -u "$fd" magic;
    exec {fd}>&-;
    if [ "$magic" = 'ELF' ]; then
        return 0;
    else
        return 1;
    fi
}
isMachO ()
{
 
    local fn="$1";
    local fd;
    local magic;
    exec {fd}< "$fn";
    LANG=C read -r -n 4 -u "$fd" magic;
    exec {fd}>&-;
    if [[ "$magic" = $(echo -ne "\xfe\xed\xfa\xcf") || "$magic" = $(echo -ne "\xcf\xfa\xed\xfe") ]]; then
        return 0;
    else
        if [[ "$magic" = $(echo -ne "\xfe\xed\xfa\xce") || "$magic" = $(echo -ne "\xce\xfa\xed\xfe") ]]; then
            return 0;
        else
            if [[ "$magic" = $(echo -ne "\xca\xfe\xba\xbe") || "$magic" = $(echo -ne "\xbe\xba\xfe\xca") ]]; then
                return 0;
            else
                return 1;
            fi;
        fi;
    fi
}
isScript ()
{
 
    local fn="$1";
    local fd;
    local magic;
    exec {fd}< "$fn";
    LANG=C read -r -n 2 -u "$fd" magic;
    exec {fd}>&-;
    if [[ "$magic" =~ \#! ]]; then
        return 0;
    else
        return 1;
    fi
}
mapOffset ()
{
 
    local -r inputOffset="$1";
    local -n outputOffset="$2";
    if (( inputOffset <= 0 )); then
        outputOffset=$((inputOffset + hostOffset));
    else
        outputOffset=$((inputOffset - 1 + targetOffset));
    fi
}
moveToOutput ()
{
 
    local patt="$1";
    local dstOut="$2";
    local output;
    for output in $(getAllOutputNames);
    do
        if [ "${!output}" = "$dstOut" ]; then
            continue;
        fi;
        local srcPath;
        for srcPath in "${!output}"/$patt;
        do
            if [ ! -e "$srcPath" ] && [ ! -L "$srcPath" ]; then
                continue;
            fi;
            if [ "$dstOut" = REMOVE ]; then
                echo "Removing $srcPath";
                rm -r "$srcPath";
            else
                local dstPath="$dstOut${srcPath#${!output}}";
                echo "Moving $srcPath to $dstPath";
                if [ -d "$dstPath" ] && [ -d "$srcPath" ]; then
                    rmdir "$srcPath" --ignore-fail-on-non-empty;
                    if [ -d "$srcPath" ]; then
                        mv -t "$dstPath" "$srcPath"/*;
                        rmdir "$srcPath";
                    fi;
                else
                    mkdir -p "$(readlink -m "$dstPath/..")";
                    mv "$srcPath" "$dstPath";
                fi;
            fi;
            local srcParent="$(readlink -m "$srcPath/..")";
            if [ -n "$(find "$srcParent" -maxdepth 0 -type d -empty 2> /dev/null)" ]; then
                echo "Removing empty $srcParent/ and (possibly) its parents";
                rmdir -p --ignore-fail-on-non-empty "$srcParent" 2> /dev/null || true;
            fi;
        done;
    done
}
nixChattyLog ()
{
 
    _nixLogWithLevel 5 "$*"
}
nixDebugLog ()
{
 
    _nixLogWithLevel 6 "$*"
}
nixErrorLog ()
{
 
    _nixLogWithLevel 0 "$*"
}
nixInfoLog ()
{
 
    _nixLogWithLevel 3 "$*"
}
nixLog ()
{
 
    [[ -z ${NIX_LOG_FD-} ]] && return 0;
    local callerName="${FUNCNAME[1]}";
    if [[ $callerName == "_callImplicitHook" ]]; then
        callerName="${hookName:?}";
    fi;
    printf "%s: %s\n" "$callerName" "$*" >&"$NIX_LOG_FD"
}
nixNoticeLog ()
{
 
    _nixLogWithLevel 2 "$*"
}
nixTalkativeLog ()
{
 
    _nixLogWithLevel 4 "$*"
}
nixVomitLog ()
{
 
    _nixLogWithLevel 7 "$*"
}
nixWarnLog ()
{
 
    _nixLogWithLevel 1 "$*"
}
noBrokenSymlinks ()
{
 
    local -r output="${1:?}";
    local path;
    local pathParent;
    local symlinkTarget;
    local -i numDanglingSymlinks=0;
    local -i numReflexiveSymlinks=0;
    local -i numUnreadableSymlinks=0;
    if [[ ! -e $output ]]; then
        nixWarnLog "skipping non-existent output $output";
        return 0;
    fi;
    nixInfoLog "running on $output";
    while IFS= read -r -d '' path; do
        pathParent="$(dirname "$path")";
        if ! symlinkTarget="$(readlink "$path")"; then
            nixErrorLog "the symlink $path is unreadable";
            numUnreadableSymlinks+=1;
            continue;
        fi;
        if [[ $symlinkTarget == /* ]]; then
            nixInfoLog "symlink $path points to absolute target $symlinkTarget";
        else
            nixInfoLog "symlink $path points to relative target $symlinkTarget";
            symlinkTarget="$(realpath --no-symlinks --canonicalize-missing "$pathParent/$symlinkTarget")";
        fi;
        if [[ $symlinkTarget = "$TMPDIR"/* ]]; then
            nixErrorLog "the symlink $path points to $TMPDIR directory: $symlinkTarget";
            numDanglingSymlinks+=1;
            continue;
        fi;
        if [[ $symlinkTarget != "$NIX_STORE"/* ]]; then
            nixInfoLog "symlink $path points outside the Nix store; ignoring";
            continue;
        fi;
        if [[ $path == "$symlinkTarget" ]]; then
            nixErrorLog "the symlink $path is reflexive";
            numReflexiveSymlinks+=1;
        else
            if [[ ! -e $symlinkTarget ]]; then
                nixErrorLog "the symlink $path points to a missing target: $symlinkTarget";
                numDanglingSymlinks+=1;
            else
                nixDebugLog "the symlink $path is irreflexive and points to a target which exists";
            fi;
        fi;
    done < <(find "$output" -type l -print0);
    if ((numDanglingSymlinks > 0 || numReflexiveSymlinks > 0 || numUnreadableSymlinks > 0)); then
        nixErrorLog "found $numDanglingSymlinks dangling symlinks, $numReflexiveSymlinks reflexive symlinks and $numUnreadableSymlinks unreadable symlinks";
        exit 1;
    fi;
    return 0
}
noBrokenSymlinksInAllOutputs ()
{
 
    if [[ -z ${dontCheckForBrokenSymlinks-} ]]; then
        for output in $(getAllOutputNames);
        do
            noBrokenSymlinks "${!output}";
        done;
    fi
}
patchELF ()
{
 
    local dir="$1";
    [ -e "$dir" ] || return 0;
    echo "shrinking RPATHs of ELF executables and libraries in $dir";
    local i;
    while IFS= read -r -d '' i; do
        if [[ "$i" =~ .build-id ]]; then
            continue;
        fi;
        if ! isELF "$i"; then
            continue;
        fi;
        echo "shrinking $i";
        patchelf --shrink-rpath "$i" || true;
    done < <(find "$dir" -type f -print0)
}
patchPhase ()
{
 
    runHook prePatch;
    local -a patchesArray;
    concatTo patchesArray patches;
    local -a flagsArray;
    concatTo flagsArray patchFlags=-p1;
    for i in "${patchesArray[@]}";
    do
        echo "applying patch $i";
        local uncompress=cat;
        case "$i" in 
            *.gz)
                uncompress="gzip -d"
            ;;
            *.bz2)
                uncompress="bzip2 -d"
            ;;
            *.xz)
                uncompress="xz -d"
            ;;
            *.lzma)
                uncompress="lzma -d"
            ;;
        esac;
        $uncompress < "$i" 2>&1 | patch "${flagsArray[@]}";
    done;
    runHook postPatch
}
patchShebangs ()
{
 
    local pathName;
    local update=false;
    while [[ $# -gt 0 ]]; do
        case "$1" in 
            --host)
                pathName=HOST_PATH;
                shift
            ;;
            --build)
                pathName=PATH;
                shift
            ;;
            --update)
                update=true;
                shift
            ;;
            --)
                shift;
                break
            ;;
            -* | --*)
                echo "Unknown option $1 supplied to patchShebangs" 1>&2;
                return 1
            ;;
            *)
                break
            ;;
        esac;
    done;
    echo "patching script interpreter paths in $@";
    local f;
    local oldPath;
    local newPath;
    local arg0;
    local args;
    local oldInterpreterLine;
    local newInterpreterLine;
    if [[ $# -eq 0 ]]; then
        echo "No arguments supplied to patchShebangs" 1>&2;
        return 0;
    fi;
    local f;
    while IFS= read -r -d '' f; do
        isScript "$f" || continue;
        read -r oldInterpreterLine < "$f" || [ "$oldInterpreterLine" ];
        read -r oldPath arg0 args <<< "${oldInterpreterLine:2}";
        if [[ -z "${pathName:-}" ]]; then
            if [[ -n $strictDeps && $f == "$NIX_STORE"* ]]; then
                pathName=HOST_PATH;
            else
                pathName=PATH;
            fi;
        fi;
        if [[ "$oldPath" == *"/bin/env" ]]; then
            if [[ $arg0 == "-S" ]]; then
                arg0=${args%% *};
                [[ "$args" == *" "* ]] && args=${args#* } || args=;
                newPath="$(PATH="${!pathName}" type -P "env" || true)";
                args="-S $(PATH="${!pathName}" type -P "$arg0" || true) $args";
            else
                if [[ $arg0 == "-"* || $arg0 == *"="* ]]; then
                    echo "$f: unsupported interpreter directive \"$oldInterpreterLine\" (set dontPatchShebangs=1 and handle shebang patching yourself)" 1>&2;
                    exit 1;
                else
                    newPath="$(PATH="${!pathName}" type -P "$arg0" || true)";
                fi;
            fi;
        else
            if [[ -z $oldPath ]]; then
                oldPath="/bin/sh";
            fi;
            newPath="$(PATH="${!pathName}" type -P "$(basename "$oldPath")" || true)";
            args="$arg0 $args";
        fi;
        newInterpreterLine="$newPath $args";
        newInterpreterLine=${newInterpreterLine%${newInterpreterLine##*[![:space:]]}};
        if [[ -n "$oldPath" && ( "$update" == true || "${oldPath:0:${#NIX_STORE}}" != "$NIX_STORE" ) ]]; then
            if [[ -n "$newPath" && "$newPath" != "$oldPath" ]]; then
                echo "$f: interpreter directive changed from \"$oldInterpreterLine\" to \"$newInterpreterLine\"";
                escapedInterpreterLine=${newInterpreterLine//\\/\\\\};
                timestamp=$(stat --printf "%y" "$f");
                tmpFile=$(mktemp -t patchShebangs.XXXXXXXXXX);
                sed -e "1 s|.*|#\!$escapedInterpreterLine|" "$f" > "$tmpFile";
                local restoreReadOnly;
                if [[ ! -w "$f" ]]; then
                    chmod +w "$f";
                    restoreReadOnly=true;
                fi;
                cat "$tmpFile" > "$f";
                rm "$tmpFile";
                if [[ -n "${restoreReadOnly:-}" ]]; then
                    chmod -w "$f";
                fi;
                touch --date "$timestamp" "$f";
            fi;
        fi;
    done < <(find "$@" -type f -perm -0100 -print0)
}
patchShebangsAuto ()
{
 
    if [[ -z "${dontPatchShebangs-}" && -e "$prefix" ]]; then
        if [[ "$output" != out && "$output" = "$outputDev" ]]; then
            patchShebangs --build "$prefix";
        else
            patchShebangs --host "$prefix";
        fi;
    fi
}
prependToVar ()
{
 
    local -n nameref="$1";
    local useArray type;
    if [ -n "$__structuredAttrs" ]; then
        useArray=true;
    else
        useArray=false;
    fi;
    if type=$(declare -p "$1" 2> /dev/null); then
        case "${type#* }" in 
            -A*)
                echo "prependToVar(): ERROR: trying to use prependToVar on an associative array." 1>&2;
                return 1
            ;;
            -a*)
                useArray=true
            ;;
            *)
                useArray=false
            ;;
        esac;
    fi;
    shift;
    if $useArray; then
        nameref=("$@" ${nameref+"${nameref[@]}"});
    else
        nameref="$* ${nameref-}";
    fi
}
printLines ()
{
 
    (( "$#" > 0 )) || return 0;
    printf '%s\n' "$@"
}
printWords ()
{
 
    (( "$#" > 0 )) || return 0;
    printf '%s ' "$@"
}
recordPropagatedDependencies ()
{
 
    declare -ra flatVars=(depsBuildBuildPropagated propagatedNativeBuildInputs depsBuildTargetPropagated depsHostHostPropagated propagatedBuildInputs depsTargetTargetPropagated);
    declare -ra flatFiles=("${propagatedBuildDepFiles[@]}" "${propagatedHostDepFiles[@]}" "${propagatedTargetDepFiles[@]}");
    local propagatedInputsIndex;
    for propagatedInputsIndex in "${!flatVars[@]}";
    do
        local propagatedInputsSlice="${flatVars[$propagatedInputsIndex]}[@]";
        local propagatedInputsFile="${flatFiles[$propagatedInputsIndex]}";
        [[ -n "${!propagatedInputsSlice}" ]] || continue;
        mkdir -p "${!outputDev}/nix-support";
        printWords ${!propagatedInputsSlice} > "${!outputDev}/nix-support/$propagatedInputsFile";
    done
}
runHook ()
{
 
    local hookName="$1";
    shift;
    local hooksSlice="${hookName%Hook}Hooks[@]";
    local hook;
    for hook in "_callImplicitHook 0 $hookName" ${!hooksSlice+"${!hooksSlice}"};
    do
        _logHook "$hookName" "$hook" "$@";
        _eval "$hook" "$@";
    done;
    return 0
}
runOneHook ()
{
 
    local hookName="$1";
    shift;
    local hooksSlice="${hookName%Hook}Hooks[@]";
    local hook ret=1;
    for hook in "_callImplicitHook 1 $hookName" ${!hooksSlice+"${!hooksSlice}"};
    do
        _logHook "$hookName" "$hook" "$@";
        if _eval "$hook" "$@"; then
            ret=0;
            break;
        fi;
    done;
    return "$ret"
}
runPhase ()
{
 
    local curPhase="$*";
    if [[ "$curPhase" = unpackPhase && -n "${dontUnpack:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = patchPhase && -n "${dontPatch:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = configurePhase && -n "${dontConfigure:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = buildPhase && -n "${dontBuild:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = checkPhase && -z "${doCheck:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = installPhase && -n "${dontInstall:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = fixupPhase && -n "${dontFixup:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = installCheckPhase && -z "${doInstallCheck:-}" ]]; then
        return;
    fi;
    if [[ "$curPhase" = distPhase && -z "${doDist:-}" ]]; then
        return;
    fi;
    showPhaseHeader "$curPhase";
    dumpVars;
    local startTime endTime;
    startTime=$(date +"%s");
    eval "${!curPhase:-$curPhase}";
    endTime=$(date +"%s");
    showPhaseFooter "$curPhase" "$startTime" "$endTime";
    if [ "$curPhase" = unpackPhase ]; then
        [ -n "${sourceRoot:-}" ] && chmod +x -- "${sourceRoot}";
        cd -- "${sourceRoot:-.}";
    fi
}
showPhaseFooter ()
{
 
    local phase="$1";
    local startTime="$2";
    local endTime="$3";
    local delta=$(( endTime - startTime ));
    (( delta < 30 )) && return;
    local H=$((delta/3600));
    local M=$((delta%3600/60));
    local S=$((delta%60));
    echo -n "$phase completed in ";
    (( H > 0 )) && echo -n "$H hours ";
    (( M > 0 )) && echo -n "$M minutes ";
    echo "$S seconds"
}
showPhaseHeader ()
{
 
    local phase="$1";
    echo "Running phase: $phase";
    if [[ -z ${NIX_LOG_FD-} ]]; then
        return;
    fi;
    printf "@nix { \"action\": \"setPhase\", \"phase\": \"%s\" }\n" "$phase" >&"$NIX_LOG_FD"
}
stripDirs ()
{
 
    local cmd="$1";
    local ranlibCmd="$2";
    local paths="$3";
    local stripFlags="$4";
    local excludeFlags=();
    local pathsNew=;
    [ -z "$cmd" ] && echo "stripDirs: Strip command is empty" 1>&2 && exit 1;
    [ -z "$ranlibCmd" ] && echo "stripDirs: Ranlib command is empty" 1>&2 && exit 1;
    local pattern;
    if [ -n "${stripExclude:-}" ]; then
        for pattern in "${stripExclude[@]}";
        do
            excludeFlags+=(-a '!' '(' -name "$pattern" -o -wholename "$prefix/$pattern" ')');
        done;
    fi;
    local p;
    for p in ${paths};
    do
        if [ -e "$prefix/$p" ]; then
            pathsNew="${pathsNew} $prefix/$p";
        fi;
    done;
    paths=${pathsNew};
    if [ -n "${paths}" ]; then
        echo "stripping (with command $cmd and flags $stripFlags) in $paths";
        local striperr;
        striperr="$(mktemp --tmpdir="$TMPDIR" 'striperr.XXXXXX')";
        find $paths -type f "${excludeFlags[@]}" -a '!' -path "$prefix/lib/debug/*" -printf '%D-%i,%p\0' | sort -t, -k1,1 -u -z | cut -d, -f2- -z | xargs -r -0 -n1 -P "$NIX_BUILD_CORES" -- $cmd $stripFlags 2> "$striperr" || exit_code=$?;
        [[ "$exit_code" = 123 || -z "$exit_code" ]] || ( cat "$striperr" 1>&2 && exit 1 );
        rm "$striperr";
        find $paths -name '*.a' -type f -exec $ranlibCmd '{}' \; 2> /dev/null;
    fi
}
stripHash ()
{
 
    local strippedName casematchOpt=0;
    strippedName="$(basename -- "$1")";
    shopt -q nocasematch && casematchOpt=1;
    shopt -u nocasematch;
    if [[ "$strippedName" =~ ^[a-z0-9]{32}- ]]; then
        echo "${strippedName:33}";
    else
        echo "$strippedName";
    fi;
    if (( casematchOpt )); then
        shopt -s nocasematch;
    fi
}
substitute ()
{
 
    local input="$1";
    local output="$2";
    shift 2;
    if [ ! -f "$input" ]; then
        echo "substitute(): ERROR: file '$input' does not exist" 1>&2;
        return 1;
    fi;
    local content;
    consumeEntire content < "$input";
    if [ -e "$output" ]; then
        chmod +w "$output";
    fi;
    substituteStream content "file '$input'" "$@" > "$output"
}
substituteAll ()
{
 
    local input="$1";
    local output="$2";
    local -a args=();
    _allFlags;
    substitute "$input" "$output" "${args[@]}"
}
substituteAllInPlace ()
{
 
    local fileName="$1";
    shift;
    substituteAll "$fileName" "$fileName" "$@"
}
substituteAllStream ()
{
 
    local -a args=();
    _allFlags;
    substituteStream "$1" "$2" "${args[@]}"
}
substituteInPlace ()
{
 
    local -a fileNames=();
    for arg in "$@";
    do
        if [[ "$arg" = "--"* ]]; then
            break;
        fi;
        fileNames+=("$arg");
        shift;
    done;
    if ! [[ "${#fileNames[@]}" -gt 0 ]]; then
        echo "substituteInPlace called without any files to operate on (files must come before options!)" 1>&2;
        return 1;
    fi;
    for file in "${fileNames[@]}";
    do
        substitute "$file" "$file" "$@";
    done
}
substituteStream ()
{
 
    local var=$1;
    local description=$2;
    shift 2;
    while (( "$#" )); do
        local replace_mode="$1";
        case "$1" in 
            --replace)
                if ! "$_substituteStream_has_warned_replace_deprecation"; then
                    echo "substituteStream() in derivation $name: WARNING: '--replace' is deprecated, use --replace-{fail,warn,quiet}. ($description)" 1>&2;
                    _substituteStream_has_warned_replace_deprecation=true;
                fi;
                replace_mode='--replace-warn'
            ;&
            --replace-quiet | --replace-warn | --replace-fail)
                pattern="$2";
                replacement="$3";
                shift 3;
                if ! [[ "${!var}" == *"$pattern"* ]]; then
                    if [ "$replace_mode" == --replace-warn ]; then
                        printf "substituteStream() in derivation $name: WARNING: pattern %q doesn't match anything in %s\n" "$pattern" "$description" 1>&2;
                    else
                        if [ "$replace_mode" == --replace-fail ]; then
                            printf "substituteStream() in derivation $name: ERROR: pattern %q doesn't match anything in %s\n" "$pattern" "$description" 1>&2;
                            return 1;
                        fi;
                    fi;
                fi;
                eval "$var"'=${'"$var"'//"$pattern"/"$replacement"}'
            ;;
            --subst-var)
                local varName="$2";
                shift 2;
                if ! [[ "$varName" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
                    echo "substituteStream() in derivation $name: ERROR: substitution variables must be valid Bash names, \"$varName\" isn't." 1>&2;
                    return 1;
                fi;
                if [ -z ${!varName+x} ]; then
                    echo "substituteStream() in derivation $name: ERROR: variable \$$varName is unset" 1>&2;
                    return 1;
                fi;
                pattern="@$varName@";
                replacement="${!varName}";
                eval "$var"'=${'"$var"'//"$pattern"/"$replacement"}'
            ;;
            --subst-var-by)
                pattern="@$2@";
                replacement="$3";
                eval "$var"'=${'"$var"'//"$pattern"/"$replacement"}';
                shift 3
            ;;
            *)
                echo "substituteStream() in derivation $name: ERROR: Invalid command line argument: $1" 1>&2;
                return 1
            ;;
        esac;
    done;
    printf "%s" "${!var}"
}
sysconfigdataHook ()
{
 
    if [ "$1" = '/nix/store/3lll9y925zz9393sa59h653xik66srjb-python3-3.13.9' ]; then
        export _PYTHON_HOST_PLATFORM='linux-x86_64';
        export _PYTHON_SYSCONFIGDATA_NAME='_sysconfigdata__linux_x86_64-linux-gnu';
    fi
}
toPythonPath ()
{
 
    local paths="$1";
    local result=;
    for i in $paths;
    do
        p="$i/lib/python3.13/site-packages";
        result="${result}${result:+:}$p";
    done;
    echo $result
}
unpackFile ()
{
 
    curSrc="$1";
    echo "unpacking source archive $curSrc";
    if ! runOneHook unpackCmd "$curSrc"; then
        echo "do not know how to unpack source archive $curSrc";
        exit 1;
    fi
}
unpackPhase ()
{
 
    runHook preUnpack;
    if [ -z "${srcs:-}" ]; then
        if [ -z "${src:-}" ]; then
            echo 'variable $src or $srcs should point to the source';
            exit 1;
        fi;
        srcs="$src";
    fi;
    local -a srcsArray;
    concatTo srcsArray srcs;
    local dirsBefore="";
    for i in *;
    do
        if [ -d "$i" ]; then
            dirsBefore="$dirsBefore $i ";
        fi;
    done;
    for i in "${srcsArray[@]}";
    do
        unpackFile "$i";
    done;
    : "${sourceRoot=}";
    if [ -n "${setSourceRoot:-}" ]; then
        runOneHook setSourceRoot;
    else
        if [ -z "$sourceRoot" ]; then
            for i in *;
            do
                if [ -d "$i" ]; then
                    case $dirsBefore in 
                        *\ $i\ *)

                        ;;
                        *)
                            if [ -n "$sourceRoot" ]; then
                                echo "unpacker produced multiple directories";
                                exit 1;
                            fi;
                            sourceRoot="$i"
                        ;;
                    esac;
                fi;
            done;
        fi;
    fi;
    if [ -z "$sourceRoot" ]; then
        echo "unpacker appears to have produced no directories";
        exit 1;
    fi;
    echo "source root is $sourceRoot";
    if [ "${dontMakeSourcesWritable:-0}" != 1 ]; then
        chmod -R u+w -- "$sourceRoot";
    fi;
    runHook postUnpack
}
updateAutotoolsGnuConfigScriptsPhase ()
{
 
    if [ -n "${dontUpdateAutotoolsGnuConfigScripts-}" ]; then
        return;
    fi;
    for script in config.sub config.guess;
    do
        for f in $(find . -type f -name "$script");
        do
            echo "Updating Autotools / GNU config script to a newer upstream version: $f";
            cp -f "/nix/store/1kzclixw4c13wxin0b6cij1zykvwp0wb-gnu-config-2024-01-01/$script" "$f";
        done;
    done
}
updateSourceDateEpoch ()
{
 
    local path="$1";
    [[ $path == -* ]] && path="./$path";
    local -a res=($(find "$path" -type f -not -newer "$NIX_BUILD_TOP/.." -printf '%T@ "%p"\0' | sort -n --zero-terminated | tail -n1 --zero-terminated | head -c -1));
    local time="${res[0]//\.[0-9]*/}";
    local newestFile="${res[1]}";
    if [ "${time:-0}" -gt "$SOURCE_DATE_EPOCH" ]; then
        echo "setting SOURCE_DATE_EPOCH to timestamp $time of file $newestFile";
        export SOURCE_DATE_EPOCH="$time";
        local now="$(date +%s)";
        if [ "$time" -gt $((now - 60)) ]; then
            echo "warning: file $newestFile may be generated; SOURCE_DATE_EPOCH may be non-deterministic";
        fi;
    fi
}
PATH="$PATH${nix_saved_PATH:+:$nix_saved_PATH}"
XDG_DATA_DIRS="$XDG_DATA_DIRS${nix_saved_XDG_DATA_DIRS:+:$nix_saved_XDG_DATA_DIRS}"
export NIX_BUILD_TOP="$(mktemp -d -t nix-shell.XXXXXX)"
export TMP="$NIX_BUILD_TOP"
export TMPDIR="$NIX_BUILD_TOP"
export TEMP="$NIX_BUILD_TOP"
export TEMPDIR="$NIX_BUILD_TOP"
eval "${shellHook:-}"

