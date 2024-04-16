export const add: (a: number, b: number) => number;

export const get_plc_info: (buf: string) => string;

export const start_plc_program: (file_name: string) => number;

export const stop_plc_program: (file_name: string) => number;

export const start_backend_server: () => number;

export const pause_or_resume_plc_program: (file_name: string, type: number) => number;

export const reset_plc_program: (file_name: string) => number;