FROM ubuntu:latest

# Instala SSH, sudo y PostgreSQL
RUN apt-get update && \
    apt-get install -y openssh-server sudo postgresql && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Crea el usuario del sistema
RUN mkdir /var/run/sshd && \
    useradd -m -s /bin/bash user && \
    echo 'user:12303122' | chpasswd && \
    echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    adduser user sudo

# Configura SSH
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config && \
    sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Copia el script de arranque
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expone puertos
EXPOSE 22 5432

# Comando de inicio
CMD ["/start.sh"]