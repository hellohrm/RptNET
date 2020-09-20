FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base

RUN ln -s /lib/x86_64-linux-gnu/libdl-2.24.so /lib/x86_64-linux-gnu/libdl.so

RUN echo "deb http://mirrors.aliyun.com/debian wheezy main contrib non-free \
deb-src http://mirrors.aliyun.com/debian wheezy main contrib non-free \
deb http://mirrors.aliyun.com/debian wheezy-updates main contrib non-free \
deb-src http://mirrors.aliyun.com/debian wheezy-updates main contrib non-free \
deb http://mirrors.aliyun.com/debian-security wheezy/updates main contrib non-free \
deb-src http://mirrors.aliyun.com/debian-security wheezy/updates main contrib non-free" > /etc/apt/sources.list

RUN apt-get update
RUN apt-get install libfontconfig1 -y
RUN apt-get install libgdiplus -y && ln -s libgdiplus.so gdiplus.dll

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
