// global.d.ts

declare global {
    var mongoose: { conn: any | null; promise: Promise<typeof import('mongoose')> | null };
  }
  
  export {};