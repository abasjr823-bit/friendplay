import React from 'react';
import { motion } from 'framer-motion';

interface ProgressBarProps {
  value: number;
  max?: number;
  color?: 'cyan' | 'pink' | 'purple' | 'lime';
}

const colorMap = {
  cyan: 'bg-gradient-to-r from-neon-cyan to-blue-500',
  pink: 'bg-gradient-to-r from-neon-pink to-red-500',
  purple: 'bg-gradient-to-r from-neon-purple to-pink-500',
  lime: 'bg-gradient-to-r from-neon-lime to-green-500',
};

export const ProgressBar: React.FC<ProgressBarProps> = ({ value, max = 100, color = 'cyan' }) => {
  const percentage = (value / max) * 100;

  return (
    <div className="w-full h-2 bg-dark-700 rounded-full overflow-hidden border border-neon-cyan border-opacity-20">
      <motion.div
        className={`h-full ${colorMap[color]}`}
        initial={{ width: 0 }}
        animate={{ width: `${percentage}%` }}
        transition={{ duration: 0.5, ease: 'easeOut' }}
      />
    </div>
  );
};

export default ProgressBar;
