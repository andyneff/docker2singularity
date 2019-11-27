ARG SINGULARITY_VERSION=v2.6
FROM singularityware/docker2singularity:${SINGULARITY_VERSION} as builder

FROM docker:18.09.8
LABEL Maintainer andy@vsi-ri.com
COPY --from=builder /usr/local /usr/local
RUN apk add --no-cache ca-certificates libseccomp squashfs-tools bash python rsync
ENV PATH="/usr/local/singularity/bin:$PATH"

ADD docker2singularity.sh /docker2singularity.sh
ADD addLabel.py /addLabel.py
ADD scripts /scripts
RUN chmod a+x docker2singularity.sh
ENTRYPOINT ["docker-entrypoint.sh", "/docker2singularity.sh"]
