import * as go from 'gojs';

export class GttsLinkTemplate {

  public static getGttsLinkTemplate(): go.Link {
    const $ = go.GraphObject.make;
    const link: go.Link =
    $(go.Link, go.Link.Orthogonal,
      { corner: 5, relinkableFrom: true, relinkableTo: true },
      $(go.Shape, { strokeWidth: 4, stroke: "#00a4a4" }));  // the link shape

    return link;
  }
}