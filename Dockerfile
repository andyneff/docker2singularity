ARG SINGULARITY_VERSION=v2.6
FROM quay.io/singularity/docker2singularity:${SINGULARITY_VERSION} as builder

RUN find /usr/local/bin -type f -not -name '*singularity*' -delete

FROM docker:18.09.8
LABEL Maintainer andy@vsi-ri.com
RUN apk add --no-cache ca-certificates libseccomp squashfs-tools bash python3 rsync
COPY --from=builder /usr/local /usr/local
ENV PATH="/usr/local/singularity/bin:$PATH"

ADD docker2singularity.sh scripts addLabel.py addEnv.py /
RUN chmod a+x docker2singularity.sh
ENTRYPOINT ["docker-entrypoint.sh", "/docker2singularity.sh"]
