FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 5104

ENV ASPNETCORE_URLS=http://+:5104

USER app
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["VueDockerPlayground.Server/VueDockerPlayground.Server.csproj", "VueDockerPlayground.Server/"]
RUN dotnet restore "VueDockerPlayground.Server/VueDockerPlayground.Server.csproj"
COPY . .
RUN apt-get update -yq 
RUN apt-get install curl gnupg -yq 
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install -y nodejs
WORKDIR "/src/VueDockerPlayground.Server"
RUN dotnet build "VueDockerPlayground.Server.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "VueDockerPlayground.Server.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "VueDockerPlayground.Server.dll"]
