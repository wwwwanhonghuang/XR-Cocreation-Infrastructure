# --- Protobuf 配置 ---
protobuf_v33.5_deps    := absl:20250512.1
protobuf_v3.19.4_deps  := # 无依赖

# --- Caffe 配置 ---
caffe_ver-openpose_deps := boost:1.90.0 \
                           opencv:4.12.0 \
                           protobuf:v3.19.4

# --- OpenPose 配置 ---
openpose_v1.7.0_deps    := caffe:ver-openpose \
                           opencv:4.12.0