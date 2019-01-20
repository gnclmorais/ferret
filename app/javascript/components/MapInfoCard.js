export default (place) => `
  <div class="card">
    <div class="card-content">
      <div class="media">
        <div class="media-content">
          <p class="title is-4">${place.name}</p>
          <!--<p class="subtitle is-6">@johnsmith</p>-->
        </div>
      </div>

      <div class="content">
        ${place.place.address}
      </div>
    </div>
  </div>
`;
