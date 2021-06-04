# Nginx Proxy OS

An OS with an nginx proxy preinstalled.

## 💻 SSH

SSH is enabled by default and you can use the following credentials to login to your Umbrel node.

- Hostname: `nginx.local`  
- User: `nginx`  
- Password: `reverseproxygobrrr`

## 🛠 Build Umbrel OS from source

> Don't trust. Verify.

Step 1. Clone this repo
```
git clone https://github.com/AaronDewes/nginx-proxy-os.git
```

Step 2. Switch to repo's directory
```
cd umbrel-os
```

Step 3. BUILD!
```
sudo ./build.sh
```

After the build completes (it can take a looooooong time), the image will be inside `deploy/` directory.

## 🔧 Advanced

**Config variables**

The `config` file has system defaults which are used when building the image and for automated builds.

- `UMBREL_VERSION` - To install the specific [Umbrel](https://github.com/getumbrel/umbrel) version.

- `GITHUB_USERNAME` - To automatically login to your Umbrel without typing a password.

- `UMBREL_REPO` - A custom git repo used to download Umbrel. `UMBREL_VERSION` is ignored if this is set, but it is required to also set `UMBREL_BRANCH`.

- `UMBREL_BRANCH` - The git branch or commit SHA in the custom repo that should be checked out.

Other Raspbian-related stuff can be found in [Raspbian's documentation](https://github.com/RPi-Distro/pi-gen/blob/master/README.md) which is still applicable.
