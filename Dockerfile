# Utiliser une version plus récente de Java (Java 11)
FROM openjdk:11-jdk

# Installer les outils nécessaires
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && apt-get clean

# Télécharger et installer Android SDK
RUN mkdir -p /usr/local/android-sdk
ENV ANDROID_SDK_ROOT /usr/local/android-sdk

RUN wget -q "https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip" -O sdk-tools.zip && \
    unzip sdk-tools.zip -d /usr/local/android-sdk/cmdline-tools && \
    mv /usr/local/android-sdk/cmdline-tools/cmdline-tools /usr/local/android-sdk/cmdline-tools/latest && \
    rm sdk-tools.zip

# Accepter les licences Android
RUN yes | /usr/local/android-sdk/cmdline-tools/latest/bin/sdkmanager --licenses

# Installer les outils de construction et l'API minimale
RUN /usr/local/android-sdk/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-24" "build-tools;30.0.3"

# Définir le dossier de travail
WORKDIR /usr/src/app

# Copier les fichiers du projet dans le conteneur
COPY . /usr/src/app

# Construire le projet
CMD ["./gradlew", "build"]
