#!/bin/bash

# Create directory structure
mkdir -p pfosix-uzerverse/{src/{core,components/LifeWheelz,store,services,utils},tests/{unit,e2e},docs,assets,docker}

# Create root files
cat > pfosix-uzerverse/flake.nix << 'EOF'
{
  description = "PFOSIX Uzerverse LifeWheelz.UIXengine - DevTeam-CORE Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
  };

  outputs = { self, nixpkgs, flake-utils, devshell, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlays.default ];
        };
      in
      {
        devShells.default = pkgs.devshell.mkShell {
          name = "lifewheelz-uixengine";
          packages = with pkgs; [
            git nodejs_20 yarn docker docker-compose
            nodePackages.typescript nodePackages.vite
            nodePackages.svelte-language-server nodePackages.three
            nodePackages.d3 nodePackages.redux cypress mdbook
          ];
          # ... rest of flake.nix content ...
        };
      }
    );
}
EOF

# Create core Glass Bead Game file
cat > pfosix-uzerverse/src/core/GlassBeadGame.ts << 'EOF'
import { Observable, Subject } from 'rxjs';
import { v4 as uuidv4 } from 'uuid';

export class GlassBeadGame {
  // ... GlassBeadGame implementation ...
}
EOF

# Create UIXengine component
cat > pfosix-uzerverse/src/components/LifeWheelz/UIXengine.ts << 'EOF'
import { GlassBeadGame, Domain, GlassBead, BeadConnection } from '../../core/GlassBeadGame';
import { WheelConfig, WheelState, ViewMode } from './types';
import { BehaviorSubject, Observable, combineLatest } from 'rxjs';
import { map } from 'rxjs/operators';
import * as THREE from 'three';
import { ForceGraph3D } from '3d-force-graph';

export class LifeWheelzUIXengine {
  // ... UIXengine implementation ...
}
EOF

# Create Docker configurations
cat > pfosix-uzerverse/docker/docker-compose.dev.yml << 'EOF'
version: '3.8'
services:
  lifewheelz-uixengine:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "3000:3000"
    volumes:
      - ./:/app
      - node_modules:/app/node_modules
    environment:
      - NODE_ENV=development
  # ... rest of docker-compose content ...
EOF

cat > pfosix-uzerverse/docker/Dockerfile.dev << 'EOF'
FROM node:20-alpine
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
EXPOSE 3000
CMD ["yarn", "dev"]
EOF

# Initialize Git repository
cd pfosix-uzerverse
git init
git add .
git commit -m "Initial commit: PFOSIX Uzerverse MVP with Glass Bead Game integration"

# Set execute permissions
chmod +x flake.nix

echo "PFOSIX Uzerverse project structure created!"
echo "Next steps:"
echo "1. cd pfosix-uzerverse"
echo "2. nix develop"
echo "3. yarn install"
echo "4. docker-compose -f docker/docker-compose.dev.yml up -d"
echo "5. Start developing your Glass Bead Game integration!"

