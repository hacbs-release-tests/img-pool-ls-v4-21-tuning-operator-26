FROM registry.access.redhat.com/ubi9/ubi:latest

RUN dnf install -y python3 python3-pip vim git wget && dnf clean all

# Size set per component by build-images.sh (100-500 MB)
ARG IMAGE_SIZE_MB=161
RUN SIZE_MB=${IMAGE_SIZE_MB} && \
    echo "Building large test image: ${SIZE_MB} MB" && \
    dd if=/dev/urandom of=/opt/data.bin bs=1M count=${SIZE_MB} 2>/dev/null && \
    echo "Image size: ${SIZE_MB} MB" > /opt/size.txt

WORKDIR /app
COPY . /app/

LABEL name="rhtap/large-snapshot-component"
LABEL cpe="cpe:/a:redhat:rhtap_large_snapshot:1::el9"
LABEL description="Large snapshot test component for rh-advisory pipeline validation"
LABEL io.k8s.description="Large snapshot test component for rh-advisory pipeline validation"
LABEL io.k8s.display-name="large-snapshot-component"
LABEL io.openshift.tags="large-snapshot"
LABEL summary="A large snapshot test container"
LABEL test-type="large-snapshot" size-range="100-500MB"
LABEL konflux.additional-tags="stable"

CMD ["/bin/bash", "-c", "cat /opt/size.txt && tail -f /dev/null"]
