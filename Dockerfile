FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository 'deb http://deb.debian.org/debian sid main' && \
    apt-get update && \
    apt-get install -y \
        libgdiplus \
        libicu-dev \
        libharfbuzz0b \
        libfontconfig1 \
        libfreetype6 \
        libpango-1.0-0 \
        libpangocairo-1.0

WORKDIR /app

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["RptNET.csproj", "RptNET/"]
RUN dotnet restore "RptNET/RptNET.csproj"
WORKDIR "/src/RptNET"
COPY . .
RUN dotnet build "RptNET.csproj" -c Release -o /app/build
 
FROM build AS publish
RUN dotnet publish "RptNET.csproj" -c Release -o /app/publish
 
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .


CMD ASPNETCORE_URLS=http://*:$PORT dotnet RptNET.dll
