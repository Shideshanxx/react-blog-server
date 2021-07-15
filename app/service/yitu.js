const Service = require("egg").Service;
const dayjs = require("dayjs");
class YituService extends Service {
  async getYitu() {
    let dayjsTime = dayjs(`${new Date()}`).format("YYYY-MM-DD");
    const res = await this.ctx.curl(
      `http://sentence.iciba.com/index.php?c=dailysentence&m=getdetail&title=${dayjsTime}`,
      {
        dataType: "json",
        method: "GET",
        data: {},
      }
    );
    return res.data;
  }
}

module.exports = YituService;
