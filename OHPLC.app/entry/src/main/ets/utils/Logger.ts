import hilog from '@ohos.hilog'

class Logger {
  private domain: number
  private prefix: string

  constructor(prefix: string) {
    this.prefix = prefix
    this.domain = 0xFF00
  }

  debug(message: string) {
    hilog.debug(this.domain, this.prefix, message)
  }

  info(message: string) {
    hilog.info(this.domain, this.prefix, message)
  }

  warn(message: string) {
    hilog.warn(this.domain, this.prefix, message)
  }

  error(message: string) {
    hilog.error(this.domain, this.prefix, message)
  }
}

export const LoggerInstance = new Logger('[OHPLC]')