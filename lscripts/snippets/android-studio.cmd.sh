## ANDROID STUDIO
export __CODEHUB_ROOT__="/codehub"
sudo update-alternatives --remove-all android-studio
sudo update-alternatives --install /usr/local/android-studio android-studio ${__CODEHUB_ROOT__}/tools/android-studio-191 191
sudo update-alternatives --install /usr/local/android-studio android-studio ${__CODEHUB_ROOT__}/tools/android-studio-193 193
sudo update-alternatives --install /usr/local/android-studio android-studio ${__CODEHUB_ROOT__}/tools/android-studio-203 203
sudo update-alternatives --config android-studio

export ANDROID_HOME="${__CODEHUB_ROOT__}/tools/android-sdk"

[ -d "/usr/local/android-studio" ] && {
  export ANDROID_STUDIO_HOME="/usr/local/android-studio"
  export PATH="${ANDROID_STUDIO_HOME}/bin:$PATH"
  alias android-studio="${ANDROID_HOME}/bin/studio.sh"
}

# /codehub/tools/android-sdk/tools/bin

# https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.1.1.21/android-studio-2022.1.1.21-linux.tar.gz