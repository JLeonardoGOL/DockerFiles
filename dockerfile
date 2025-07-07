FROM ubuntu:22.04

# Evitar interacción al instalar paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Actualiza e instala OpenSSH y sudo
RUN apt-get update && \
    apt-get install -y openssh-server sudo && \
    mkdir /var/run/sshd

# Crea usuario con contraseña
RUN useradd -m -s /bin/bash user && \
    echo 'user:12303122' | chpasswd && \
    adduser user sudo

# Permitir login con contraseña SSH
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config

# Evita que el contenedor se cierre por falta de TTY
CMD ["/usr/sbin/sshd", "-D"]

# Exponer puerto SSH
EXPOSE 22