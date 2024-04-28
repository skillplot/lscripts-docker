```
FROM ubuntu:latest

# Install sudo package
RUN apt-get update && \
    apt-get install -y sudo && \
    rm -rf /var/lib/apt/lists/*

# Add user 'blah' and grant sudo privileges
ARG USERNAME=blah
RUN useradd -m $USERNAME && \
    echo "$USERNAME ALL=(ALL:ALL) ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Switch to user 'blah'
USER $USERNAME

CMD ["/bin/bash"]
```


```
FROM ubuntu:latest

# Add user 'blah' with a specified home directory
ARG USERNAME=blah
ARG USERHOME=/path/to/new/home/blah
RUN useradd -m -d $USERHOME $USERNAME && \
    echo "$USERNAME ALL=(ALL:ALL) ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Switch to user 'blah'
USER $USERNAME

CMD ["/bin/bash"]
```