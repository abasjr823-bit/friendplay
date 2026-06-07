// README for developers

# FriendPlay Development Guide

## Project Structure

```
friendplay/
├── app/                      # Next.js app directory
│   ├── api/                 # API routes
│   ├── game/                # Game pages
│   ├── leaderboard/         # Leaderboard page
│   ├── play/                # Play/game selection
│   ├── profile/             # User profile
│   ├── room/                # Room management
│   ├── settings/            # Settings page
│   ├── welcome/             # Welcome page
│   ├── layout.tsx           # Root layout
│   └── page.tsx             # Home page
├── components/              # React components
│   ├── common/              # Shared components
│   ├── game/                # Game components
│   ├── home/                # Home page components
│   ├── layout/              # Layout components
│   ├── room/                # Room components
│   └── ui/                  # UI components
├── context/                 # React context
├── features/                # Feature modules
│   ├── drawguess/          # Draw & Guess logic
│   ├── spyfall/            # Spyfall logic
│   └── leaderboard/        # Leaderboard logic
├── hooks/                   # Custom React hooks
├── lib/                     # Utilities & helpers
├── public/                  # Static files
├── server/                  # Express backend
│   ├── db/                 # Database schema
│   ├── routes/             # API routes
│   ├── socket/             # Socket.IO handlers
│   └── index.ts            # Server entry
├── services/                # API services
├── store/                   # Zustand stores
├── styles/                  # Global styles
└── types/                   # TypeScript types
```

## Getting Started

### Prerequisites
- Node.js 18+
- npm or yarn
- PostgreSQL (via Supabase)

### Installation

```bash
# Clone repository
git clone https://github.com/abasjr823-bit/friendplay.git
cd friendplay

# Install dependencies
npm install

# Copy environment variables
cp .env.example .env.local

# Start development servers
npm run dev
```

The app runs on:
- Frontend: http://localhost:3000
- Backend: http://localhost:3001

### Set Up Database

1. Create Supabase project
2. Copy credentials to `.env.local`
3. Run schema from `server/db/schema.sql`

## Key Technologies

### Frontend
- **Next.js 15** - React framework
- **React 19** - UI library
- **TypeScript** - Type safety
- **Tailwind CSS** - Styling
- **Framer Motion** - Animations
- **Zustand** - State management
- **Socket.IO Client** - Real-time communication

### Backend
- **Express** - Web framework
- **Socket.IO** - WebSocket library
- **Supabase** - Database & auth
- **Node.js** - Runtime

## Development Workflow

### Creating a New Page

```typescript
// app/my-page/page.tsx
'use client';

import React from 'react';
import { RootLayout } from '@/components/layout/RootLayout';
import Card from '@/components/ui/Card';

export default function MyPage() {
  return (
    <RootLayout>
      <div className="py-20">
        <Card>
          <h1>My Page</h1>
        </Card>
      </div>
    </RootLayout>
  );
}
```

### Creating a New Component

```typescript
// components/my-component/MyComponent.tsx
import React from 'react';
import { motion } from 'framer-motion';

interface MyComponentProps {
  title: string;
}

export const MyComponent: React.FC<MyComponentProps> = ({ title }) => {
  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
    >
      {title}
    </motion.div>
  );
};

export default MyComponent;
```

### Using Hooks

```typescript
import { useTranslation } from '@/hooks';
import { useSocket } from '@/hooks/useSocket';
import { useCurrentUser } from '@/hooks';

function MyComponent() {
  const i18n = useTranslation();
  const { emit, on } = useSocket();
  const user = useCurrentUser();

  return <div>{i18n('home')}</div>;
}
```

### Styling Guidelines

Use Tailwind classes with custom colors:
- `text-neon-cyan` - Cyan accent
- `text-neon-pink` - Pink accent
- `text-neon-purple` - Purple accent
- `text-neon-lime` - Lime accent
- `glassmorphism` - Glass effect
- `neon-glow-cyan` - Glow shadow

## Socket.IO Events

### Room Events
```typescript
socket.emit('room:create', { name, game, maxPlayers })
socket.emit('room:join', { roomCode, playerId, nickname })
socket.emit('room:leave', { roomCode, playerId })
socket.emit('room:player-ready', { playerId, isReady })
socket.emit('room:start-game', { roomCode, hostId })
socket.emit('room:kick-player', { roomCode, playerId })
```

### Game Events
```typescript
socket.emit('game:action', { playerId, action, data })
socket.on('game:started', handleGameStart)
socket.on('game:action', handleGameAction)
socket.on('game:round-end', handleRoundEnd)
```

### Chat Events
```typescript
socket.emit('chat:message', { roomCode, message, nickname })
socket.on('chat:message', handleMessage)
```

## API Endpoints

### Players
- `POST /api/players` - Create player
- `GET /api/players/:id` - Get player
- `PUT /api/players/:id` - Update player

### Rooms
- `GET /api/rooms` - List rooms
- `POST /api/rooms` - Create room
- `GET /api/rooms/code/:code` - Get room by code
- `POST /api/rooms/:roomId/join` - Join room
- `POST /api/rooms/:roomId/leave` - Leave room
- `POST /api/rooms/:roomId/start` - Start game
- `POST /api/rooms/:roomId/kick` - Kick player

### Matches
- `POST /api/matches` - Create match
- `GET /api/matches/:matchId` - Get match
- `POST /api/matches/:matchId/end` - End match

### Leaderboard
- `GET /api/leaderboard` - Get global leaderboard
- `GET /api/leaderboard/friends/:userId` - Get friends leaderboard

## State Management

### Zustand Stores

```typescript
import { usePlayerStore, useRoomStore, useGameStore, useUIStore } from '@/store';

// Player
const { currentUser, setCurrentUser } = usePlayerStore();

// Room
const { currentRoom, players, addPlayer } = useRoomStore();

// Game
const { gameState, setGameState, updateGameState } = useGameStore();

// UI
const { language, setLanguage, soundEnabled } = useUIStore();
```

## Testing

```bash
# Run tests
npm test

# Run with coverage
npm test -- --coverage
```

## Deployment

See `DEPLOYMENT.md` for detailed deployment instructions.

## Contributing

1. Create feature branch
2. Make changes
3. Test locally
4. Submit pull request

## Troubleshooting

### Socket connection issues
- Check Socket URL in `.env.local`
- Ensure backend is running
- Check browser console for errors

### Database errors
- Verify Supabase connection
- Run schema migrations
- Check table permissions

### Build errors
- Clear `.next` folder
- Reinstall dependencies
- Check TypeScript errors

## Resources

- [Next.js Docs](https://nextjs.org/docs)
- [Socket.IO Docs](https://socket.io/docs)
- [Supabase Docs](https://supabase.com/docs)
- [Tailwind CSS](https://tailwindcss.com)
- [Framer Motion](https://www.framer.com/motion)

---

Questions? Open an issue on GitHub!
