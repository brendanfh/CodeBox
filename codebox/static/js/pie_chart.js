// Generated by CoffeeScript 2.4.1
(function() {
  $(document).ready(function() {
    return $('piechart').each(function(_, p) {
      var $p, anim, canvas, ctx, fill_perc, i, j, ref, segments, total;
      $p = $(p);
      segments = $p.attr('data-segments');
      canvas = document.createElement("canvas");
      canvas.width = 256;
      canvas.height = 256;
      $p.append(canvas);
      ctx = canvas.getContext("2d");
      total = 0;
      for (i = j = 1, ref = segments; (1 <= ref ? j <= ref : j >= ref); i = 1 <= ref ? ++j : --j) {
        total += parseInt($p.attr(`data-segment-${i}`));
      }
      fill_perc = 0.01;
      anim = function() {
        var acc, color, k, ratio, ref1;
        acc = 0;
        for (i = k = 1, ref1 = segments; (1 <= ref1 ? k <= ref1 : k >= ref1); i = 1 <= ref1 ? ++k : --k) {
          ratio = (parseInt($p.attr(`data-segment-${i}`))) * fill_perc;
          color = $p.attr(`data-segment-${i}-color`);
          ctx.beginPath();
          ctx.moveTo(128, 128);
          ctx.arc(128, 128, 128, -2 * Math.PI * (ratio + acc) / total, -2 * Math.PI * acc / total);
          ctx.closePath();
          ctx.fillStyle = color;
          ctx.fill();
          acc += ratio;
        }
        fill_perc += fill_perc / 10 + 0.01;
        if (fill_perc >= 1) {
          fill_perc = 1;
          window.requestAnimationFrame(anim);
        }
        if (fill_perc < 1) {
          return window.requestAnimationFrame(anim);
        }
      };
      return window.requestAnimationFrame(anim);
    });
  });

}).call(this);

//# sourceMappingURL=pie_chart.js.map