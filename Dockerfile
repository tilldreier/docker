FROM ubuntu:18.04
LABEL maintainer="Till Dreier"
LABEL version="1.0"

# Install required packages for next installs
RUN apt-get update && apt-get install -y wget gnupg2 curl chromium-browser build-essential

# Set chrome environment variable for karma tests
ENV CHROME_BIN /usr/bin/chromium-browser

# Install Cloud Foundry CLI
RUN wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -
RUN echo "deb https://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
RUN apt-get update && apt-get install -y cf7-cli

# Setup alias for CF7 command
RUN echo "alias cf='cf7'" >> ~/.bashrc
RUN echo -e '#!/bin/bash\ncf7 "$@"' > /usr/bin/cf && chmod +x /usr/bin/cf

# Install community repository and MTA plugin
RUN cf7 add-plugin-repo CF-Community https://plugins.cloudfoundry.org
RUN cf7 install-plugin multiapps -f

# Install NodeJS
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# Update npm to latest version
RUN npm install npm@latest -g

# Install SAP SDK & mbt
RUN npm i -g @sap/cds-dk
RUN npm i -g mbt

# Run cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Run command line
CMD /bin/bash