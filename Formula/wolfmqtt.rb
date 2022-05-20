class Wolfmqtt < Formula
  desc "Small, fast, portable MQTT client C implementation"
  homepage "https://github.com/wolfSSL/wolfMQTT"
  url "https://github.com/wolfSSL/wolfMQTT/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "fdf6727da994eaea491b44d2db3e7f40cd968cb14db29191bf1f240e1e1ef81a"
  license "GPL-2.0-or-later"
  head "https://github.com/wolfSSL/wolfMQTT.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wolfmqtt"
    sha256 cellar: :any, mojave: "5681ea9550aff13cdfdb8fa84e32b714e30a076798b2c8d2d89318519257f062"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "wolfssl"

  def install
    args = %W[
      --disable-silent-rules
      --disable-dependency-tracking
      --infodir=#{info}
      --mandir=#{man}
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-nonblock
      --enable-mt
      --enable-mqtt5
      --enable-propcb
      --enable-sn
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOT
      #include <wolfmqtt/mqtt_client.h>
      int main() {
        MqttClient mqttClient;
        return 0;
      }
    EOT
    system ENV.cc, "test.cpp", "-L#{lib}", "-lwolfmqtt", "-o", "test"
    system "./test"
  end
end
